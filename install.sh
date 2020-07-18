#!/bin/bash

conda_link="https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh"

if ! [ -x "$(command -v yay)" ] || ! [ -d /opt/yay-git ]; then
  sudo pacman -Syu --needed git
  cd /opt
  sudo rm -rf yay-git
  sudo git clone https://aur.archlinux.org/yay-git.git
  sudo chown -R joshua:joshua ./yay-git
  cd yay-git
  makepkg -si
fi

# install basic stuff
yay -Syu --needed visual-studio-code-bin icaclient google-chrome vlc \
  plex-media-server tixati gcc mesa nodejs npm yarn go spotify discord \
  slack-desktop jdk8-openjdk cloc dos2unix baobab

# clock
if ! [ -x "$(command -v ntpd)" ]; then
  yay -Syu --needed ntp
  systemctl enable ntpd
  systemctl start ntpd
fi

# spotify ad block
if ! [ -x "$(command -v spotify)" ] || ! [ -d /opt/spotify-ad-block ]; then
  cd /opt
  rm -rf spotify-ad-block
  sudo git clone https://github.com/x0uid/SpotifyAdBlock spotify-ad-block
  cd spotify-ad-block
  cat hosts | sudo tee -a /etc/hosts
fi

# install docker
if ! [ -x "$(command -v docker)" ]; then
  yay -Syu --needed docker
  sudo gpasswd -a $USER docker
  newgrp docker
  sudo systemctl enable docker
  sudo systemctl start docker
  docker run hello-world
fi

# install anaconda
if ! [ -x "$(command -v conda)" ]; then
  yay -Syu --needed libxau libxi libxss libxtst libxcursor libxcomposite \
    libxdamage libxfixes libxrandr libxrender mesa-libgl  alsa-lib libglvnd
  rm -rf conda_install.sh
  wget "$conda_link" -O conda_install.sh
  chmod +x conda_install.sh
  ./conda_install.sh
  rm -rf conda_install.sh
fi

