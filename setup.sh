#!/bin/bash

SETUP_NVIM="$1"
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || return
REPLACE_ALL=

showdiff() {
    d=$(diff --brief "$1" "$2")
    if [[ -z $REPLACE_ALL && -n $d  ]]; then
        d=$(batdiff --color "$1" "$2" || diff --color=always "$1" "$2")
        echo "diff between $1 and $2:"
        echo "$d"
        echo -n "Do you want to replace it [a]ll/[Y]es/[n]o/[c]ancel? "
        read -r ac
        case "$ac" in
            a|all) REPLACE_ALL=1; cp "$2" "$1" ;;
            y|yes|'') cp "$2" "$1" ;;
            n|no) return ;;
            c|cancel) echo Exiting && exit 0 ;;
            *) echo Enter a proper value!; exit 1 ;;
        esac
    elif [[ -n $d ]]; then
        cp "$2" "$1"
    fi
}

if [[ -n "$SETUP_NVIM" ]]; then
    git clone "https://github.com/AstroNvim/AstroNvim" "$HOME/.config/nvim"
    cp -r "./.config/nvim-user/user/" "$HOME/.config/nvim/lua/user/"
    echo "Your neovim setuped!"
fi

for dir in $(find .config/* -type d); do
    if [[ "$dir" == *"nvim"* ]]; then continue; fi
    if [[ ! -d "$HOME/$dir" ]]; then
        echo -n "Create directory $HOME/$dir [Y]es/[n]o? "
        read -r ac 
        case "$ac" in
            yes|y|'') mkdir -p "$HOME/$dir" ;;
            no|n) continue ;;
            *) echo Enter a proper value!; exit 1 ;;
        esac
    fi
    for file in $(find $dir -type f); do
        if [[ "$file" == *"hypr/wallpaper.jpg" && -e "$HOME/.config/hypr/wallpaper.jpg" ]]; then continue; fi
        if [[ ! -e "$HOME/$file" ]]; then
            cp "$DIR/$file" "$HOME/$file"
        else
            showdiff "$HOME/$file" "$DIR/$file"
        fi
    done
done

for script in $(find .local/bin -type f); do
    if [[ ! -e "$HOME/$script" ]]; then
        cp "$DIR/$script" "$HOME/$script"
    else
        showdiff "$HOME/$script" "$DIR/$script"
    fi
done
