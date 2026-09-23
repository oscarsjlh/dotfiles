#!/usr/bin/env bash
# ============================================================================
# Noctalia Greeter + greetd setup for sway (Arch Linux)
# https://github.com/noctalia-dev/noctalia-greeter
# ============================================================================
# Idempotent. Run as your normal user (yay refuses to build as root);
# it will ask for your sudo password once.
#
#   ~/dotfiles/setup-noctalia-greeter.sh
#
# What it does:
#   1. install greetd, accountsservice, xdg-desktop-portal-wlr (official repos)
#   2. install noctalia-greeter (AUR, via yay)
#   3. install /etc/greetd/config.toml            <- from system/greetd/
#   4. install /var/lib/noctalia-greeter/greeter.toml  <- from system/noctalia-greeter/
#   5. enable (not start) greetd + accounts-daemon
#   6. allow passwordless appearance sync for your login user
#
# It deliberately does NOT start greetd: greetd.service Conflicts=getty@tty1,
# so starting it now would tear down your current console/tmux session.
# Reboot (or `sudo systemctl start greetd`) when you are ready.
# ============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREETER_USER="greeter"                     # created by greetd's sysusers.d rule
LOGIN_USER="${SUDO_USER:-$(id -un)}"
SWAY_SESSION_NAME="Sway"                   # Name= of /usr/share/wayland-sessions/sway.desktop

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
step() { echo -e "${BLUE}[STEP]${NC}  $1"; }

# ---------------------------------------------------------------------------
# 0. Preflight
# ---------------------------------------------------------------------------
step "Preflight checks..."

[[ $EUID -ne 0 ]] || { error "Do not run as root; run as '$LOGIN_USER' so yay can build AUR packages."; exit 1; }
grep -q 'ID=arch' /etc/os-release || { error "This script targets Arch Linux."; exit 1; }
command -v yay >/dev/null || { error "yay not found — install an AUR helper first."; exit 1; }
[[ -f /usr/share/wayland-sessions/sway.desktop ]] || warn "sway.desktop not found — the greeter cannot offer a Sway session."

sudo -v
echo ""

# ---------------------------------------------------------------------------
# 1. Official-repo packages
# ---------------------------------------------------------------------------
step "Installing greetd, accountsservice, xdg-desktop-portal-wlr..."
sudo pacman -Sy --needed --noconfirm greetd accountsservice xdg-desktop-portal-wlr

# Arch creates the 'greeter' account from greetd's sysusers.d rule at boot; run
# it now so the state dir chown below works without a reboot first.
sudo systemd-sysusers
id greeter >/dev/null 2>&1 || { error "'greeter' user still missing after systemd-sysusers."; exit 1; }
info "greeter account: $(id greeter)"

# ---------------------------------------------------------------------------
# 2. Greeter from the AUR (post-install creates /var/lib/noctalia-greeter)
# ---------------------------------------------------------------------------
step "Installing noctalia-greeter (AUR — takes a few minutes on first build)..."
yay -S --needed --noconfirm noctalia-greeter

SESSION_WRAPPER="$(command -v noctalia-greeter-session || true)"
[[ -n "$SESSION_WRAPPER" ]] || { error "noctalia-greeter-session not in PATH after install."; exit 1; }
info "session wrapper: $SESSION_WRAPPER"

grep -q "noctalia-greeter-session" "$REPO_DIR/system/greetd/config.toml" || {
  error "system/greetd/config.toml does not point at noctalia-greeter-session."
  exit 1
}
if [[ "$SESSION_WRAPPER" != "/usr/bin/noctalia-greeter-session" ]]; then
  warn "Wrapper lives at $SESSION_WRAPPER, not /usr/bin — update system/greetd/config.toml."
fi

# Make sure the pinned default session is actually discoverable.
if command -v noctalia-greeter >/dev/null && ! noctalia-greeter sessions 2>/dev/null | grep -qi "^${SWAY_SESSION_NAME}$"; then
  warn "'$SWAY_SESSION_NAME' not listed by 'noctalia-greeter sessions'. Available:"
  noctalia-greeter sessions 2>/dev/null | sed 's/^/         /' || true
fi
echo ""

# ---------------------------------------------------------------------------
# Helpers: install a config file, backing up any different existing version
# ---------------------------------------------------------------------------
install_config() {
  local src="$1" dst="$2" mode="$3" owner="$4"

  # sudo because /var/lib/noctalia-greeter is 0750 greeter-owned.
  if sudo test -e "$dst" && sudo cmp -s "$src" "$dst"; then
    info "unchanged: $dst"
    return 0
  fi
  if sudo test -e "$dst"; then
    local bak="$dst.bak.$(date +%Y%m%d-%H%M%S)"
    sudo cp -a "$dst" "$bak"
    warn "backed up existing $dst -> $bak"
  fi
  sudo install -Dm "$mode" -o "$owner" -g "$owner" "$src" "$dst"
  info "installed: $dst"
}

# ---------------------------------------------------------------------------
# 3. greetd config
# ---------------------------------------------------------------------------
step "Configuring greetd..."
install_config "$REPO_DIR/system/greetd/config.toml" /etc/greetd/config.toml 0644 root
info "greetd will run: $(grep -m1 '^command' /etc/greetd/config.toml)"

# ---------------------------------------------------------------------------
# 4. Greeter declarative config (state dir is owned by the greeter user)
# ---------------------------------------------------------------------------
step "Configuring noctalia-greeter..."
sudo install -d -m 0750 -o "$GREETER_USER" -g "$GREETER_USER" /var/lib/noctalia-greeter
install_config "$REPO_DIR/system/noctalia-greeter/greeter.toml" \
  /var/lib/noctalia-greeter/greeter.toml 0644 "$GREETER_USER"
echo ""

# ---------------------------------------------------------------------------
# 5. Enable services (NOT started — see header comment)
# ---------------------------------------------------------------------------
step "Enabling services..."
sudo systemctl enable greetd.service
sudo systemctl enable accounts-daemon.service   # user avatars on the login screen
info "display-manager.service -> $(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || echo '?')"
warn "greetd is enabled but NOT running. Reboot to see the greeter."

# ---------------------------------------------------------------------------
# 6. Passwordless Noctalia -> greeter appearance sync
# ---------------------------------------------------------------------------
step "Authorising passwordless appearance sync for '$LOGIN_USER'..."
if sudo noctalia-greeter passwordless-sync enable "$LOGIN_USER"; then
  noctalia-greeter passwordless-sync status "$LOGIN_USER" || true
else
  warn "passwordless-sync enable failed — sync will keep asking for a password (still works)."
fi

# ---------------------------------------------------------------------------
# 7. Summary
# ---------------------------------------------------------------------------
cat <<EOF

==========================================
  NOCTALIA GREETER SETUP COMPLETE
==========================================

Done:
  * greetd + noctalia-greeter installed
  * /etc/greetd/config.toml        -> $SESSION_WRAPPER (user: $GREETER_USER)
  * /var/lib/noctalia-greeter/greeter.toml -> session '$SWAY_SESSION_NAME', user '$LOGIN_USER'
  * greetd.service + accounts-daemon.service enabled (not started)
  * passwordless sync authorised for $LOGIN_USER

Next:
  1. Reboot, then log in through the Noctalia greeter (sway starts via
     /usr/share/wayland-sessions/sway.desktop).
  2. In sway: Noctalia Settings -> Security -> Noctalia Greeter ->
     enable "Auto-Sync Greeter" (or press "Sync Now") to mirror wallpaper,
     palette and monitor layout on the login screen.
  3. Edit look-and-feel declaratively in ~/dotfiles/system/noctalia-greeter/greeter.toml,
     then re-run this script. Restart greetd to apply:
       sudo systemctl restart greetd      # kills your session

If the greeter ever fails to start:
  * Ctrl-Alt-F2 .. F6 still give you a normal text login (greetd only owns tty1)
  * journalctl -u greetd -b   /   systemctl status greetd
  * sudo systemctl disable --now greetd && sudo systemctl start getty@tty1
    to go back to plain console login
EOF
