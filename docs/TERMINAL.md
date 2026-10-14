# Terminal, tmux & Neovim reference

Personal cheat-sheet for the terminal stack on this machine.

- **Terminal:** Ghostty (`/usr/bin/ghostty`)
- **Multiplexer:** tmux 3.4
- **Editor:** Neovim (live config in `~/.config/nvim`)
- **Shell:** zsh + oh-my-zsh
- **WM:** i3

---

## 1. How a terminal launches

`$mod+Return` (i3) runs `i3-sensible-terminal`, which falls through to
`x-terminal-emulator` → `/usr/bin/ghostty`. `$TERMINAL` is unset.

tmux auto-starts from `~/.zshrc`, so each new terminal gets its own fresh session:

```zsh
if [[ -o interactive && -z "$TMUX" && -z "$SSH_CONNECTION" && -z "$TMUX_NO_AUTO" ]]; then
    exec tmux new-session
fi
```

- Already inside tmux (`$TMUX` set) → no nesting.
- `TMUX_NO_AUTO=1 zsh` (or any non-zsh shell) → plain shell, no tmux.
- SSH sessions are skipped.

To change the behaviour globally, edit that block in `~/.zshrc`.
Alternative (ghostty-only): add `command = tmux new-session` to
`~/dotfiles/apps/ghostty/config`.

---

## 2. tmux

Config: `~/.config/tmux/tmux.conf` → `~/dotfiles/apps/tmux/tmux.conf`
**Prefix = `Ctrl-a`** (press `Ctrl-a`, release, then the key).

### Keybindings

| Keys              | Action                                   |
| ----------------- | ---------------------------------------- |
| `prefix d`        | detach (session keeps running)           |
| `prefix s`        | session tree / switcher                  |
| `prefix S`        | new named session (prompts)              |
| `prefix $`        | rename current session                   |
| `prefix X`        | kill session (asks to confirm)           |
| `prefix c`        | new window (in current directory)        |
| `prefix ,`        | rename window                            |
| `prefix n` / `p`  | next / previous window                   |
| `prefix 1…9`      | jump to window                           |
| `prefix &`        | kill window (asks)                       |
| `prefix \|`       | split left / right                       |
| `prefix -`        | split top / bottom                       |
| `prefix x`        | kill pane (asks)                         |
| `prefix h/j/k/l`  | move between panes                       |
| `prefix H/J/K/L`  | resize pane (repeatable)                 |
| `prefix z`        | zoom pane fullscreen (toggle)            |
| `prefix Space`    | cycle pane layouts                       |
| `prefix [`        | copy mode (vi keys; `v` select, `y` copy)|
| `prefix Y`        | copy selection → system clipboard (xclip)|
| `prefix r`        | reload config                            |
| `prefix t`        | clock                                    |
| `prefix :`        | tmux command prompt                      |
| `prefix ?`        | list every binding                       |
| `prefix Ctrl-a`   | send a literal `Ctrl-a` to the program   |
| `Alt-Left/Right`  | previous / next window (no prefix)       |

Mentally: **session = project, window = tab, pane = split.**
Window/pane numbering starts at **1**.

### Shell one-liners

```bash
tmux                      # attach to latest session
tmux new -s work          # new named session
tmux ls                   # list sessions
tmux a -t work            # attach to "work"
tmux kill-session -t work
tmux kill-server          # nuke everything
```

### Interop notes

- `escape-time 10` + `focus-events on` keep nvim responsive inside tmux.
- `terminal-overrides ",*256col*:Tc"` enables truecolor for nvim themes.
- Copy uses `xclip` (installed, X11). OSC-52 passthrough is also on.
- Want `Ctrl-h/j/k/l` to move seamlessly between nvim splits and tmux panes?
  Add the `vim-tmux-navigator` plugin to nvim plus the matching tmux binds.

---

## 3. Neovim

Live config: `~/.config/nvim` (its own git repo:
`github.com/Banacount/my-neovim-setup-hehe`).
Plugin manager: **lazy.nvim** (`:Lazy`). **Leader = `Space`.**

### Keymaps defined by this config

| Keys                  | Action                                     |
| --------------------- | ------------------------------------------ |
| `Space f`             | `:Ex` — netrw file browser                 |
| `Space b`             | Telescope buffers                          |
| `Space lg`            | Telescope live_grep                        |
| `Space ml`            | list marked netrw files                    |
| `Space y` (visual)    | yank selection → system clipboard          |
| `Alt j` / `Alt k`     | next / previous quickfix entry             |

Neovide-only: `Ctrl-=` / `Ctrl--` / `Ctrl-0` scale, `Ctrl-V` paste.

### Custom commands

- `:Diagnose` — open diagnostic float
- `:Diagnose list` — diagnostics into quickfix
- `:MarkedFiles` — list marked netrw files

### Options & plugins

- `number` + `relativenumber`, `nowrap`, block cursor in insert, termguicolors.
- **Real tabs** — `expandtab=false`, tabstop/softtabstop/shiftwidth = 4.
- Theme: catppuccin **mocha** (transparent), lualine + bufferline (`█` tab indicator).
- LSP: `lua_ls` + `jdtls` (Mason installs the rest). Completion: `blink.cmp`.
- Treesitter: python, css, html, js, ts, java, rust, markdown.
- `hbac` auto-closes old buffers; render-markdown; guess-indent + indent-blankline.
- Startup dashboard; `typr` / `vim-be-good` for practise.

### Gotchas

- The startup dashboard advertises `Space ff`, `Space fb`, `Space gg` —
  **not actually bound** in `lua/config/my-basic-setup.lua`.
- `~/.local/share/nvim/lazy` still holds LazyVim-era plugins (noice, snacks,
  dap, mini.\*, tokyonight…). `:Lazy clean` removes unused ones.
- `~/dotfiles/apps/nvim` is a synced copy of this config. The previous
  LazyVim version was backed up to `~/dotfiles/apps/nvim.lazyvim.backup`.
  `~/.config/nvim` stays the live source of truth (and its own git repo).
  Note: it is **not** a symlink, so running `./install.sh i3` would move the
  live dir to `*.backup` and link the dotfiles copy instead — edit the live
  repo, then re-sync if you want them to match.

---

## 4. i3 quick reference (`Mod4` = Super)

| Keys                      | Action                          |
| ------------------------- | ------------------------------- |
| `Mod4+Enter`              | terminal (ghostty → tmux)       |
| `Mod4+d`                  | rofi launcher                   |
| `Mod4+q`                  | kill window                     |
| `Mod4+f`                  | fullscreen toggle               |
| `Mod4+h` / `Mod4+v`       | split horizontal / vertical     |
| `Mod4+j k l ;`            | focus left/down/up/right        |
| `Mod4+Shift+j k l ;`      | move window                     |
| `Mod4+1…0`                | workspace                       |
| `Mod4+Shift+1…0`          | move window to workspace        |
| `Mod4+r`                  | resize mode (then j/k/l/;)      |
| `Mod4+Shift+c`            | reload i3 config                |
| `Mod4+Shift+r`            | restart i3                      |
| `Mod4+Shift+e`            | exit i3 (asks)                  |
| `Print`                   | flameshot screenshot            |

---

## 5. Ghostty

Config: `~/.config/ghostty/config` → `~/dotfiles/apps/ghostty/config`.
FiraCode Nerd Font 12, opacity 0.75, bg `#0a0a12`, fg `#e6e6ff`,
selection `#00f5ff`, no decorations, scrollback 10000, `shell-integration = zsh`.

Since tmux runs inside ghostty, tmux owns scrollback/copy in a tmux pane.

---

## 6. Dotfiles workflow

Configs under `~/.config` are symlinks into `~/dotfiles` (created by
`install.sh`). Editing `~/.config/foo` really edits `~/dotfiles/...`.

```bash
cd ~/dotfiles
git status
git add -A
git commit -m "…"
git push
```

Re-link everything for i3: `./install.sh i3`
(it backs up anything it would replace to `*.backup`).

Optional aliases:

```bash
alias ta='tmux a -t main'
alias tl='tmux ls'
alias tn='tmux new -s'
```
