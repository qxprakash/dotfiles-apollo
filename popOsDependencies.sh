#!/bin/bash
shopt -s expand_aliases

## install regolith

wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list


sudo apt update
sudo apt install regolith-desktop
sudo apt upgrade

## restart



## install polybar rofi nitrogen lxappearance acpi

sudo apt install polybar rofi nitrogen lxappearance libarchive-tools nemo xfce4-terminal gnome-tweaks intel-media-va-driver-non-free


## installing firefox nightly and brave

sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa
sudo apt update
sudo apt install firefox-trunk

sudo apt install apt-transport-https curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser




## install fonts

wget https://github.com/Prakashh21/Fonts/archive/refs/tags/v4.0.zip
sudo bsdtar --strip-components=1 -xvf v4.0.zip -C /usr/share/fonts/
fc-cache -vf

## install dracula icons

cd ~
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
sudo unzip Dracula.zip -d /usr/share/icons

wget https://github.com/dracula/gtk/archive/master.zip
sudo unzip master.zip -d /usr/share/icons
sudo mv /usr/share/themes/gtk-master/ /usr/share/themes/dracula


# install picom build dependencies

sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev

# install picom build tools

sudo apt-get install meson ninja-build

#install nodeJS

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

## remove regolith config

sudo apt remove regolith-i3-workspace-config


## pull config

rm -Rf ~/.bashrc ~/.Xresources ~/.bash_profile ~/.config/gtk-3.0 ~/.config/gtk-2.0 ~/.config/xfce4/ ~/.config/i3/ ~/.config/polybar ~/.config/picom ~/add-dots.sh ~/.config/kitty ~/.config/rofi ~/.zshrc ~/.zprofile ~/packages.txt ~/setup.sh ~/.Xnord ~/.config/nitrogen/ ~/.config/neofetch ~/.profile   

echo "dotfiles" >> .gitignore

git clone --bare https://github.com/Prakashh21/dotfiles-apollo.git $HOME/dotfiles

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

config checkout popOs
config config status.showUntrackedFiles no

git config --global user.email "prakashope@gmail.com"
git config --global user.name "Prakash"

exit 0
