#!/bin/bash
shopt -s expand_aliases

export DEBIAN_FRONTEND=noninteractive


## install regolith

# Register the Regolith public key to your local apt
wget -qO - https://archive.regolith-desktop.com/regolith.key | gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

# Add the repository URL to your local apt
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] https://archive.regolith-desktop.com/ubuntu/stable noble v3.3" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# Update apt
sudo apt update
echo Regolith Desktop can be installed by executing: sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille

sudo apt install -y regolith-desktop
sudo apt upgrade -y

## restart



## install polybar rofi nitrogen lxappearance acpi

sudo apt install -y polybar rofi flameshot transmission-gtk telegram-desktop mpv htop feh gh python3 python3-pip vim git nitrogen lxappearance libarchive-tools nemo xfce4-terminal gnome-tweaks intel-media-va-driver-non-free regolith-i3-workspace-config python-is-python3 network-manager-gnome


## install postman

# flatpak install flathub com.getpostman.Postman -y


## installing firefox nightly and brave

sudo add-apt-repository -y ppa:ubuntu-mozilla-daily/ppa
sudo apt update -y
sudo apt install firefox-trunk

sudo apt install -y apt-transport-https curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update -y

sudo apt install -y brave-browser


## download deb files

mkdir deb_installers
cd deb_installers

# download google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# download vs code
#curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868 

# download ferdium 

curl -o ferdium.deb -L https://github.com/ferdium/ferdium-app/releases/download/v6.7.0/Ferdium-linux-6.7.0-amd64.deb

# install .deb files
sudo dpkg -i *.deb

## install vs code 

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt -y install code

## install fonts

sudo apt install fonts-firacode

wget https://github.com/Prakashh21/Fonts/archive/refs/tags/v4.0.zip
sudo bsdtar --strip-components=1 -xvf v4.0.zip -C /usr/share/fonts/
fc-cache -vf

## vscode terminal powerline fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts/

## install dracula icons

cd ~
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
sudo unzip Dracula.zip -d /usr/share/icons

wget https://github.com/dracula/gtk/archive/master.zip
sudo unzip master.zip -d /usr/share/themes
sudo mv /usr/share/themes/gtk-master/ /usr/share/themes/dracula

## Install Mousepad

sudo apt install -y wget apt-transport-https gnupg2 software-properties-common
sudo add-apt-repository -y ppa:xubuntu-dev/staging
sudo apt install -y mousepad

## Prevent app store from getting started on startup

cd /etc/xdg/autostart/

sudo mv io.elementary.appcenter-daemon.desktop io.elementary.appcenter-daemon.desktop.bak

# install picom build dependencies

sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libpcre3-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev

# picom extra dependency on ubuntu server
# commented the below code because a separate branch for ubuntu server was created
# sudo apt install libpcre3-dev


# install picom build tools

sudo apt-get -y install meson ninja-build


########## install pywal

sudo apt install -y imagemagick

pip3 install pywal


#install nodeJS

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

## remove regolith config

sudo apt remove -y regolith-i3-workspace-config

## pull config

rm -Rf ~/.bashrc ~/.Xresources ~/.bash_profile ~/.config/gtk-3.0 ~/.config/gtk-2.0 ~/.config/xfce4/ ~/.config/i3/ ~/.config/polybar ~/.config/picom ~/add-dots.sh ~/.config/kitty ~/.config/rofi ~/.zshrc ~/.zprofile ~/packages.txt ~/setup.sh ~/.Xnord ~/.config/nitrogen/ ~/.config/neofetch ~/.profile   

echo "dotfiles" >> .gitignore

git clone --bare https://github.com/prakashex/dotfiles-apollo.git $HOME/dotfiles

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

config checkout popOs
config config status.showUntrackedFiles no

git config --global user.email "qxprakash@gmail.com"
git config --global user.name "Prakash"





## install picom build dependencies
sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
libxcb-shape0-dev libpcre3-dev libxcb-render-util0-dev libxcb-render0-dev \
libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev \
libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev \
libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev \
meson ninja-build

## build & install picom fork
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

# install vscode context menu extension for nautilus 

# wget -qO- https://raw.githubusercontent.com/cra0zy/code-nautilus/master/install.sh | bash

# docker install docs

# docker engine
# https://docs.docker.com/engine/install/ubuntu/

# # docker compose standalone 

# Link -- https://docs.docker.com/compose/install/standalone/
# # after installing docker componse standalone 
# sudo usermod -aG docker $USER                  # to add myself to docker group
# sudo chgrp docker /usr/local/bin/docker-compose     # to give docker-compose to docker group,
# sudo chmod 750 /usr/local/bin/docker-compose   # to allow docker group users to execute it

## automatic install script 

## yes Y | command-that-asks-for-input

## wget https://raw.githubusercontent.com/prakashex/dotfiles-apollo/popOs/install.sh && chmod +x install.sh &&  yes Y | ./install.sh





exit 0
