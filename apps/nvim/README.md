# 💤 LazyVim

Personal [LazyVim](https://github.com/LazyVim/LazyVim) configuration.
Managed from `~/dotfiles` — `~/.config/nvim` is a symlink to this directory.

## Layout

- `init.lua` / `lua/config/*` — LazyVim bootstrap and core tweaks
- `lazyvim.json` — enabled [extras](https://lazyvim.github.io/configuration/extras)
  (`<leader>xe` opens the extra browser)
- `lua/plugins/*.lua` — plugin overrides / additions not covered by extras

## Enabled extras

| Group       | Extras |
| ----------- | ------ |
| Languages   | clangd (C/C++), docker, java, json, kotlin, markdown, python, rust, toml, typescript, yaml |
| Formatting  | prettier |
| Linting     | eslint |
| Development | dap (debugging core), mini-surround, inc-rename, treesitter-context |

Also configured manually (no extra exists):

- **Shell/Bash**: `bashls` LSP, `shfmt` formatting, `shellcheck` linting

## Language tooling notes

- **Java / Kotlin**: needs a JDK — OpenJDK 21 is installed on this machine.
- **C / C++**: `clangd` comes from Mason (prebuilt), `gcc` handles compilation.
- **Rust**: `rust-analyzer` comes from your `~/.cargo` toolchain.
- **Go**: intentionally **not** enabled — the Go toolchain isn't installed.
  To enable: install Go, then add `lazyvim.plugins.extras.lang.go` in
  `lazyvim.json` (or via `<leader>xe`).

## Requirements

- Neovim >= 0.11.2 (0.12.x installed)
- Nerd Font (JetBrainsMono Nerd Font is installed system-wide)
- `git`, `gcc`/`make` (for treesitter parsers), `tree-sitter` CLI in `~/.local/bin`
- `ripgrep` + `fd` in `~/.local/bin` for the pickers

## Optional extras (not enabled)

- `lang.go` (once the Go toolchain is installed)
- AI completions: `ai.copilot`, `ai.codeium`, … via `<leader>xe`