#!/bin/bash

SETUP_NVIM=$1
REPLACE_ALL=
DID_OPERATION=
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || return

showdiff() {
    d=$(diff --brief "$1" "$2")
    if [[ -z $REPLACE_ALL && -n $d  ]]; then
        d=$(batdiff --color "$1" "$2" || diff --color=always "$1" "$2")
        echo "differece between $1 and $2:"
        echo "$d"
        echo -n "Do you want to replace it [a]ll/[Y]es/[n]o/[c]ancel? "
        read -r ac
        case "$ac" in
            a|all) REPLACE_ALL=1; DID_OPERATION=1; cp "$2" "$1" ;;
            y|yes|'') DID_OPERATION=1; cp "$2" "$1" ;;
            n|no) return ;;
            c|cancel) echo "Canceled."; exit 0 ;;
            *) echo "Enter a proper value!"; exit 1 ;;
        esac
    elif [[ -n $d ]]; then
        cp "$2" "$1"
    fi
}

if [[ "$SETUP_NVIM" == "nvim" ]]; then
    git clone "https://github.com/AstroNvim/AstroNvim" "$HOME/.config/nvim"
    cp -r "./.config/nvim-user/user/" "$HOME/.config/nvim/lua/user/"
    echo "Your neovim setted up!"
    exit 0
else
    echo "Run \`./setup.sh nvim\` to setup neovim."
fi

dirs=$(find .config/* -type d)
for dir in $dirs; do
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
    files=$(find "$dir" -type f)
    for file in $files; do
        [[ "$file" == *"hypr/wallpaper.jpg" && -e "$HOME/.config/hypr/wallpaper.jpg" ]] && continue
        if [[ ! -e "$HOME/$file" ]]; then
            cp "$DIR/$file" "$HOME/$file"
            DID_OPERATION=1
        else
            showdiff "$HOME/$file" "$DIR/$file"
        fi
    done
done

scripts=$(find .local/bin -type f)
for script in $scripts; do
    if [[ ! -e "$HOME/$script" ]]; then
        cp "$DIR/$script" "$HOME/$script"
        DID_OPERATION=1
    else
        showdiff "$HOME/$script" "$DIR/$script"
    fi
done

if [[ -z "$DID_OPERATION" ]]; then
    echo "Nothing to do."
else
    echo "You're all settled."
fi

