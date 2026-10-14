#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

echo "Dotfiles: $DOTFILES"

usage() {
    echo "Usage: $0 <wm>"
    echo
    echo "Available WMs:"
    echo "  i3"
    echo "  dwm"
    echo "  hyprland"
    exit 1
}

backup() {
    local target="$1"

    [ -e "$target" ] || [ -L "$target" ] || return 0

    # If the target is already one of our own dotfiles symlinks, there is no
    # user data to preserve -- just drop it. (Prevents re-runs from turning
    # .backup files into symlinks to the newly-installed config.)
    if [ -L "$target" ]; then
        local existing
        existing="$(readlink "$target")"
        case "$existing" in
            "$DOTFILES"/*)
                echo "Removing existing dotfiles symlink: $target"
                rm -f "$target"
                return 0
                ;;
        esac
    fi

    local backup="${target}.backup"

    if [ -e "$backup" ] || [ -L "$backup" ]; then
        backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    fi

    echo "Backing up: $target -> $backup"
    mv "$target" "$backup"
}

link_config() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    backup "$target"

    echo "Linking:"
    echo "  $target -> $source"

    ln -s "$source" "$target"
}

install_shared() {
    echo
    echo "Installing shared applications..."

    # nvim: the live ~/.config/nvim is the source of truth (it has its own git
    # repo). Do NOT symlink it here -- dotfiles/apps/nvim is kept in sync from
    # it by hand. Symlinking would move the live config aside and replace it.
    link_config "$DOTFILES/apps/polybar" "$CONFIG/polybar"
    link_config "$DOTFILES/apps/rofi" "$CONFIG/rofi"
    link_config "$DOTFILES/apps/picom/picom.conf" "$CONFIG/picom/picom.conf"
    link_config "$DOTFILES/apps/ghostty/config" "$CONFIG/ghostty/config"
    link_config "$DOTFILES/apps/tmux/tmux.conf" "$CONFIG/tmux/tmux.conf"
    link_config "$DOTFILES/apps/pipewire/pipewire-pulse.conf.d" "$CONFIG/pipewire/pipewire-pulse.conf.d"
}

install_shell() {
    echo
    echo "Installing shell configuration..."

    # zsh: these live directly in $HOME (not ~/.config), so link them there.
    link_config "$DOTFILES/shell/.zshrc"  "$HOME/.zshrc"
    link_config "$DOTFILES/shell/.zshenv" "$HOME/.zshenv"
}

install_i3() {
    echo
    echo "Installing i3 configuration..."

    link_config "$DOTFILES/wm/i3/config" "$CONFIG/i3/config"
    link_config "$DOTFILES/wm/i3/scripts" "$CONFIG/i3/scripts"
    link_config "$DOTFILES/wallpapers" "$CONFIG/wallpapers"

    install_shared
    install_shell
}

[ $# -eq 1 ] || usage

WM="$1"

case "$WM" in
    i3)
        install_i3
        ;;
    dwm)
        echo "dwm support not implemented yet."
        exit 1
        ;;
    hyprland)
        echo "Hyprland support not implemented yet."
        exit 1
        ;;
    *)
        echo "Unknown WM: $WM"
        usage
        ;;
esac

echo
echo "Installation complete."