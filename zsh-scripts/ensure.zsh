source "$HOME/.local/share/scripts/packages.zsh"
source "$HOME/.local/share/scripts/rocks.zsh"

if ! pacman -Q "yay-bin" &> /dev/null; then
    echo "Installing package yay-bin..."
    git clone https://aur.archlinux.org/yay-bin "/tmp/yay-bin"
    cd /tmp/yay-bin
    makepkg -si
fi

function install_packages {
    for package in "${packages[@]}"; do
        if ! yay -Q "$package" &> /dev/null; then
            echo "Installing package $package..."
            sudo yay -S --noconfirm "$package"
        fi
    done
}

function install_rocks {
    for rock in "${rocks[@]}"; do
        cmd="$(luarocks list --porcelain ${rock})"
        if [[ -z $cmd ]] then
            echo "Installing rock ${rock}..."
            sudo luarocks install "${rock}"
        fi
    done
}

install_packages
install_rocks
