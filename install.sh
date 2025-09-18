#!/bin/bash
shopt -s expand_aliases

# Update system
sudo pacman -Syu

# Install base packages (matching PopOS script structure)
sudo pacman -Sy ttf-font-awesome qt5ct papirus-icon-theme noto-fonts-emoji noto-fonts ttf-fira-code htop btop rofi telegram-desktop alacritty xfce4-taskmanager element-desktop obs-studio gparted flameshot deluge-gtk git nitrogen vim github-cli p7zip polybar nemo nemo-fileroller intel-media-driver intel-gpu-tools libva-intel-driver libva ffmpeg libva-utils libarchive xpdf mpv acpi lxappearance python python-pip --noconfirm

# Install nvidia drivers
sudo pacman -S nvidia-installer-dkms --noconfirm
# nvidia-installer-dkms -t
# sudo nvidia-installer-dkms
# sudo systemctl reboot

# Development tools
sudo pacman -Sy pycharm-community-edition intellij-idea-community-edition jdk-openjdk nodejs npm python docker docker-compose meson uthash cmake --noconfirm

# Docker post install (commented out - uncomment if needed)
# sudo systemctl start docker.service
# sudo systemctl enable docker.service
# sudo usermod -aG docker $USER

# AUR packages (matching PopOS script)
yay -Sy freedownloadmanager spotify-adblock zoom visual-studio-code-bin google-chrome firefox-nightly-bin sublime-text-4 dracula-gtk-theme ferdium-bin brave-bin --noconfirm

## Fonts installation (enhanced from PopOS script)
sudo pacman -Sy ttc-iosevka --noconfirm
yay -Sy nerd-fonts-source-code-pro otf-inconsolata-powerline-git --noconfirm

# Download and install additional fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip
sudo unzip -o FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Meslo.zip
sudo unzip -o Meslo.zip -d /usr/share/fonts

wget https://github.com/Prakashh21/Fonts/archive/refs/tags/v5.0.zip
sudo bsdtar --strip-components=1 -xvf v5.0.zip -C /usr/share/fonts/
fc-cache -vf

## Install Dracula theme and icons
cd ~
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
sudo unzip -o Dracula.zip -d /usr/share/icons

wget https://github.com/dracula/gtk/archive/master.zip
sudo unzip -o master.zip -d /usr/share/themes
sudo mv /usr/share/themes/gtk-master/ /usr/share/themes/dracula

## Install Python packages
pip install --user pywal imagemagick

## Install picom build dependencies
sudo pacman -Sy libxext libxcb libxcb xcb-util-renderutil libxcb xcb-util libpixman libconfig libdbus libgl libpcre2 libev libxcb libepoxy libxcb --noconfirm

## Build & install picom fork (matching PopOS script)
echo ">>> Building custom Picom"
mkdir -p ~/source && cd ~/source
if [ ! -d "picom" ]; then
    git clone https://github.com/pijulius/picom.git
fi
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
cd ~
rm -rf ~/source

######################################################################################################

## Nemo setup (same as original)
wget https://raw.githubusercontent.com/mhsattarian/nemo-open-in-vscode/master/vscode.nemo_action -O ~/.local/share/nemo/actions/vscode.nemo_action

## Setting default terminal as alacritty for nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

######################################################################################################

## Firefox configuration notes
echo "Firefox WebRender setup:"
echo "1. Go to about:config"
echo "2. Set gfx.webrender.all = true"
echo "3. Set gfx.webrender.software = false" 
echo "4. Set gfx.webrender.compositor = true"
echo "5. Set media.ffmpeg.vaapi.enabled = true"
echo "6. Set media.rdd-vpx.enabled = true"

## Firefox theme installation
echo "To install Firefox theme:"
echo "1. Set toolkit.legacyUserProfileCustomizations.stylesheets = true in about:config"
echo "2. Run: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/mut-ex/minimal-functional-fox/master/install.sh)\""

######################################################################################################

## Chrome hardware acceleration setup
echo "For Chrome hardware acceleration:"
echo "Edit /usr/share/applications/google-chrome.desktop"
echo "Add flags: --enable-features=VaapiVideoDecoder --use-gl=desktop --disable-features=UseChromeOSDirectVideoDecoder"

######################################################################################################

## Starting dotfiles setup script

# Files to remove before config checkout
rm -Rf ~/.bashrc ~/.Xresources ~/.bash_profile ~/.config/gtk-3.0 ~/.config/gtk-2.0 ~/.config/xfce4/ ~/.config/i3/ ~/.config/polybar ~/.config/picom ~/add-dots.sh ~/.config/kitty ~/.config/rofi ~/.zshrc ~/.zprofile ~/packages.txt ~/setup.sh ~/.Xnord ~/.config/nitrogen/ ~/.config/neofetch ~/.profile   

echo "dotfiles" >> .gitignore

# Clone dotfiles (using same repo as PopOS script)
git clone --bare https://github.com/prakashex/dotfiles-apollo.git $HOME/dotfiles

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Checkout arch branch instead of popOs
config checkout arch 2>/dev/null || {
    echo "Checking out main/master branch as fallback"
    config checkout
}
config config status.showUntrackedFiles no

# Git global config
git config --global user.email "qxprakash@gmail.com"
git config --global user.name "Prakash"

## Optional: Install and configure zsh with oh-my-zsh
echo "To install zsh and oh-my-zsh:"
echo "sudo pacman -Sy zsh zsh-completions"
echo "chsh -s /bin/zsh"
echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
echo "yay -Sy zsh-theme-powerlevel9k-git --noconfirm"
echo "echo 'source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme' >> ~/.zshrc"

echo "Setup completed! Please reboot your system."
exit 0
