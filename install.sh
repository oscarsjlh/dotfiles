#!/bin/bash
# ============================================================================
# Dotfiles Bootstrap Script for Arch Linux
# ============================================================================
# Usage:
#   git clone <your-dotfiles-repo> ~/dotfiles
#   cd ~/dotfiles
#   ./install.sh
#
# This script is idempotent — safe to run multiple times.
# ============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Colors & logging
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
step() { echo -e "${BLUE}[STEP]${NC}  $1"; }

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
backup_if_exists() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    info "Backed up $target -> $BACKUP_DIR"
  fi
}

symlink_dotfile() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
    return 0
  fi

  backup_if_exists "$dst"
  mkdir -p "$(dirname "$dst")"
  rm -rf "$dst"
  ln -s "$src" "$dst"
  info "Linked $dst -> $src"
}

# ---------------------------------------------------------------------------
# 1. OS Detection
# ---------------------------------------------------------------------------
step "Detecting OS..."
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* ]]; then
    error "This script is designed for Arch Linux. Detected: $ID"
    exit 1
  fi
else
  error "Cannot detect OS. /etc/os-release not found."
  exit 1
fi
info "Detected Arch Linux"

# ---------------------------------------------------------------------------
# 2. Symlink dotfiles
# ---------------------------------------------------------------------------
step "Symlinking dotfiles..."

for file in "$DOTFILES_DIR"/.*; do
  [[ -f "$file" ]] || continue
  name=$(basename "$file")
  [[ "$name" == ".gitignore" ]] && continue
  symlink_dotfile "$file" "$HOME/$name"
done

if [[ -d "$DOTFILES_DIR/.config" ]]; then
  for item in "$DOTFILES_DIR/.config"/*; do
    name=$(basename "$item")
    symlink_dotfile "$item" "$HOME/.config/$name"
  done
fi

if [[ -d "$DOTFILES_DIR/.pi/agent" ]]; then
  mkdir -p "$HOME/.pi/agent"
  for item in "$DOTFILES_DIR/.pi/agent"/*; do
    [[ -f "$item" ]] || continue
    name=$(basename "$item")
    symlink_dotfile "$item" "$HOME/.pi/agent/$name"
  done
fi

if [[ -d "$DOTFILES_DIR/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
  for item in "$DOTFILES_DIR/.local/bin"/*; do
    name=$(basename "$item")
    symlink_dotfile "$item" "$HOME/.local/bin/$name"
  done
fi

if [[ -d "$DOTFILES_DIR/Pictures" ]]; then
  symlink_dotfile "$DOTFILES_DIR/Pictures" "$HOME/Pictures"
fi

# ---------------------------------------------------------------------------
# 3. Install official repository packages
# ---------------------------------------------------------------------------
step "Installing packages from official repositories..."

sudo pacman -Sy --needed --noconfirm \
  base-devel \
  git curl wget \
  zsh zoxide atuin starship fzf tmux wl-clipboard \
  go gcc make nodejs npm bun python python-pip jq kubectl \
  stylua shfmt prettier \
  lua-language-server bash-language-server yaml-language-server \
  dockerfile-language-server gopls vscode-json-languageserver \
  ruff pyright terraform terragrunt \
  sway hyprland niri \
  noctalia \
  greetd accountsservice xdg-desktop-portal-wlr \
  waybar fuzzel wofi \
  grim slurp swappy wf-recorder \
  cliphist swaylock \
  brightnessctl \
  wpaperd \
  easyeffects pipewire wireplumber \
  pcmanfm \
  firefox ghostty \
  solaar rclone \
  polkit-gnome \
  gnome-keyring \
  playerctl \
  lazygit \
  2>/dev/null || warn "Some packages may have failed, continuing..."

# ---------------------------------------------------------------------------
# 4. Install yay (AUR helper) if missing
# ---------------------------------------------------------------------------
step "Checking for AUR helper (yay)..."

if ! command -v yay &>/dev/null; then
  info "Installing yay..."
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay" --depth 1
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
  info "yay installed"
else
  info "yay already installed"
fi

# ---------------------------------------------------------------------------
# 5. Install AUR packages
# ---------------------------------------------------------------------------
step "Installing AUR packages..."

yay -S --needed --noconfirm \
  carapace-bin \
  noctalia-greeter \
  2>/dev/null || warn "Some AUR packages may have failed, continuing..."

# ---------------------------------------------------------------------------
# 5b. Login screen: greetd + Noctalia Greeter (configs live in ./system/)
# ---------------------------------------------------------------------------
step "Configuring greetd + Noctalia Greeter..."
if [[ -x "$DOTFILES_DIR/setup-noctalia-greeter.sh" ]]; then
  "$DOTFILES_DIR/setup-noctalia-greeter.sh" || warn "greeter setup incomplete — run ~/dotfiles/setup-noctalia-greeter.sh manually"
fi

# ---------------------------------------------------------------------------
# 6. Install global npm packages
# ---------------------------------------------------------------------------
step "Installing global npm packages..."

npm_prefix=$(npm config get prefix 2>/dev/null || echo "$HOME/.local/share/npm-global")
mkdir -p "$npm_prefix/bin"
export PATH="$npm_prefix/bin:$PATH"

npm install -g @fsouza/prettierd 2>/dev/null || warn "prettierd install failed"

# ---------------------------------------------------------------------------
# 7. Install Go tools
# ---------------------------------------------------------------------------
step "Installing Go tools..."

export GOPATH=${GOPATH:-$HOME/go}
export PATH="$PATH:$GOPATH/bin"
mkdir -p "$GOPATH/bin"

go install golang.org/x/tools/cmd/goimports@latest 2>/dev/null || true

# ---------------------------------------------------------------------------
# 8. Tmux Plugin Manager
# ---------------------------------------------------------------------------
step "Installing TPM (Tmux Plugin Manager)..."

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" --depth 1
  info "TPM installed"
else
  info "TPM already installed"
fi

# ---------------------------------------------------------------------------
# 9. Zsh setup
# ---------------------------------------------------------------------------
step "Configuring zsh..."

mkdir -p "$HOME/.cache/zsh"
touch "$HOME/zsh_history"

if [[ "$SHELL" != *"zsh"* ]]; then
  chsh -s /usr/bin/zsh
  info "Default shell changed to zsh. Log out and back in to apply."
else
  info "zsh is already the default shell"
fi

zsh -n "$HOME/.zshrc" && info ".zshrc syntax OK" || warn ".zshrc has syntax issues"

# ---------------------------------------------------------------------------
# 10. Neovim setup
# ---------------------------------------------------------------------------
step "Configuring Neovim..."

mkdir -p "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"

if command -v nvim &>/dev/null; then
  info "Running Neovim headless sync (this may take a minute)..."
  timeout 120 nvim --headless -c 'Lazy! sync' -c 'qa' 2>/dev/null || true
  info "Neovim plugins synced"
else
  warn "nvim not found — install it first: sudo pacman -S neovim"
fi

# ---------------------------------------------------------------------------
# 11. Missing custom binary warnings / stubs
# ---------------------------------------------------------------------------
step "Checking for custom scripts..."

# if ! command -v qs &>/dev/null && [[ ! -f "$HOME/.local/bin/qs" ]]; then
#     warn "'qs' (noctalia-shell) not found — required by sway and niri configs"
#     warn "  Install from: https://github.com/noctalia-shell/qs (or your source)"
# fi
#
# if ! command -v urlsel &>/dev/null && [[ ! -f "$HOME/.local/bin/urlsel" ]]; then
#     warn "'urlsel' not found — required by sway/hyprland binds"
#     warn "  This is a custom script; add it to ~/dotfiles/.local/bin/ to persist it"
# fi
#
# if [[ ! -f "$HOME/.local/bin/sway-session-init" ]]; then
#   warn "'sway-session-init' not found — required by sway exec.conf"
#   warn "  Creating a minimal stub at ~/.local/bin/sway-session-init"
#   cat >"$HOME/.local/bin/sway-session-init" <<'EOF'
# #!/bin/bash
# # Stub sway session init script
# # Customize this for your setup (e.g. set GTK theme, start dbus services, etc.)
# export GTK_THEME=dracula
# EOF
#   chmod +x "$HOME/.local/bin/sway-session-init"
# fi

# if [[ ! -f "$HOME/.local/bin/screenshot.sh" ]]; then
#   warn "'screenshot.sh' not found — required by niri config"
#   warn "  Creating a minimal stub at ~/.local/bin/screenshot.sh"
#   cat >"$HOME/.local/bin/screenshot.sh" <<'EOF'
# #!/bin/bash
# # Screenshot script for niri
# grim -g "$(slurp)" - | swappy -f -
# EOF
#   chmod +x "$HOME/.local/bin/screenshot.sh"
# fi

# ---------------------------------------------------------------------------
# 12. Pi setup
# ---------------------------------------------------------------------------
step "Setting up Pi configuration..."

if [[ ! -d "$HOME/.local/share/searxng-mcp" ]]; then
  git clone https://github.com/oscarsjlh/searxng-mcp.git "$HOME/.local/share/searxng-mcp" --depth 1
  info "Cloned searxng-mcp to ~/.local/share/searxng-mcp"
else
  info "searxng-mcp already cloned"
fi

if command -v pi &>/dev/null; then
  pi update --extensions 2>/dev/null || warn "Pi extension update skipped (may require auth)"
else
  warn "'pi' not found in PATH — install it from https://pi.dev"
fi

# ---------------------------------------------------------------------------
# 13. Summary
# ---------------------------------------------------------------------------
echo ""
echo "=========================================="
echo "  DOTFILES INSTALL COMPLETE"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. If shell was changed, LOG OUT and back in"
echo "  2. Open tmux, press PREFIX + I to install tmux plugins"
echo "  3. Open nvim and run :checkhealth"
echo "  4. Update SEARXNG_BASE_URL in ~/.pi/agent/mcp.json if your SearXNG instance is not on localhost:8080"
echo ""
echo "Compositor launch (pick one):"
echo "  sway          # Tiling Wayland compositor (i3-like)"
echo "  Hyprland      # Dynamic tiling with animations"
echo "  niri          # Scrollable-tiling compositor"
echo ""
echo "Optional extras:"
echo "  pip install jupytext    # If you use Jupyter notebooks"
echo ""
