# Herdr migration

This setup targets herdr 0.9.5. The old `.tmux.conf` and tmux packages stay
available for fallback. Ghostty and Alacritty now start herdr.

## Start

The config is linked at `~/.config/herdr`. Open a new terminal to start herdr.
Do not start herdr inside the old tmux session. Keep that session open until
you have checked the new setup. Existing tmux panes do not move to herdr.

After a config change, run `herdr server reload-config` inside herdr.
Some UI startup settings need a new client.

## Keys

Press `Ctrl+a`, release it, then press the action key.

| Action key | Action |
| --- | --- |
| `?` | Show active keys |
| `k` / `j` | Split right / down |
| Arrow keys | Focus a pane |
| `h` / `l` | Focus left / right |
| `Ctrl+h/j/k/l` | Resize a pane |
| `c` | New tab in the current directory |
| `n` / `p` | Next / previous tab |
| `<` / `>` | Move the current tab left / right |
| `1..9` | Select a tab |
| `f` | Open the project picker |
| `w` | Open the workspace picker |
| `b` | Show or hide the sidebar |
| `z` | Zoom the pane |
| `[` | Enter copy mode |
| `d` | Detach; keep the panes running |

Without a prefix, `Ctrl+Space` selects the next pane and `Ctrl+backslash`
selects the last pane. `Ctrl+h/j/k/l` stays available to applications.
Neovim uses those keys for its own splits, not for herdr pane focus.
Neovim's `<leader>gt` opens a pane below the current file's directory.

## Project picker

Inside herdr, `sessions [directory]` focuses an existing workspace or creates
one. The workspace label is its full directory path, with `~/` for home.
Do not rename these labels if you want the picker to reuse the workspace.

The `Ctrl+a f` popup runs the same script. Press Esc to cancel.
Outside herdr, `sessions [directory]` starts or attaches the default client.
An optional directory sets the launch directory; it does not change an
existing workspace. Use the picker after attachment to choose a project.

## Differences from tmux

- Workspaces replace project sessions. Tabs replace windows.
- There is no Vim-aware focus handoff. Use the prefix and arrow keys to
  move between herdr panes.
- The installed Wiremux plugin has only a tmux backend. It is disabled in
  herdr. Its agent-send shortcuts are not migrated.
- Copy mode has built-in `v` selection and `y` copy. Mouse selection copies
  automatically. Use the terminal's paste shortcut, such as `Ctrl+Shift+v`,
  instead of tmux's `prefix P`.
- History is limited to 10 MB per pane, not 10,000 lines.
- Resize keys use herdr's native step, not tmux's 15-cell step.
- The `prefix Space` last-window shortcut, `prefix Ctrl+Space` send-prefix
  shortcut, dot-only tab labels, and Neovim status hook are not reproduced.
- Herdr handles color, escape timing, images, and tab numbering itself.
  TPM and tmux passthrough settings do not apply.
- The theme, sidebar, pane borders, and tab bar use Herdr's defaults.
  Custom keybindings and non-visual settings stay in place.

To use the fallback, start `tmux attach || tmux` from a shell outside herdr.
The old `.config/ghostty/tmux.sh` path now launches herdr for external
shortcuts that still use that path.

## Checks

From the repository root:

```sh
python -m unittest discover -s tests -p 'test_herdr_migration.py'
```

The tests use a temporary home and a separate server socket. They do not
change your running session.

References:
- https://herdr.dev/tui/docs/configuration/
- https://herdr.dev/tui/docs/keyboard/
- https://herdr.dev/tui/docs/cli-reference/
