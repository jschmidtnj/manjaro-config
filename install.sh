#!/bin/bash

conda_link="https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh"

# https://github.com/arch4edu/arch4edu/wiki/Add-arch4edu-to-your-Archlinux
vim /etc/pacman.conf
# https://github.com/arch4edu/mirrorlist/blob/master/mirrorlist.arch4edu
# Server = https://arch4edu.keybase.pub/$arch

# sudo vim /etc/pacman.d/mirrorlist
# latest packages
## Country : United_States
# Server = https://mirrors.edge.kernel.org/archlinux/$repo/os/$arch
sudo pacman-mirrors --fasttrack && sudo pacman -Syyu

if ! [ -x "$(command -v yay)" ]; then
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
  cd -
  rm -rf yay-bin
fi

# if it gets stuck, run makepkg -si in ~/.cache/yay/<package_name>/
# then yay -S <package_name>
# update sha with mkpkgsha
# install basic stuff
yay -S - < pkglist.txt

# google drive ocamlfuse
opam init
opam install google-drive-ocamlfuse

# fix permissions for node + npm
# see https://github.com/mklement0/n-install
sudo chown -R $(whoami) /usr/lib/node_modules

# install arduino
if ! [ -x "$(command -v arduino)" ]; then
  yay -Syu --needed arduino arduino-avr-core
  user=$(whoami)
  sudo usermod -a -G dialout $user
  sudo usermod -a -G tty $user
  sudo usermod -a -G lock $user
  sudo usermod -a -G uucp $user
fi

# install boinc (seti)
yay -Syu --needed boinc
usermod -a -G boinc $(whoami)

git config --global core.editor "vim"

# https://github.com/bulletmark/libinput-gestures
sudo gpasswd -a $USER input
libinput-gestures-setup autostart

# mongo
if ! [ -x "$(command -v mongod)" ]; then
  # add key manually for lib curl (temporary)
  gpg --keyserver keyserver.ubuntu.com --recv-key \
    27EDEAF22F3ABCEB50DB9A125CC908FDB71E12C2
  yay -Syu --needed mongodb-bin
  sudo systemctl enable mongodb
  sudo systemctl start mongodb
  yay -Syu mongodb-compass
fi

# nvidia driver
# https://wiki.archlinux.org/index.php/NVIDIA
# for version: https://www.nvidia.com/Download/index.aspx
# https://wiki.manjaro.org/index.php?title=Configure_NVIDIA_(non-free)_settings_and_load_them_on_Startup
# needs a reboot to take effect
if ! [ -x "$(command -v nvidia-settings)" ]; then
  mhwd -l
  sudo mhwd -i pci video-nvidia-450xx
  yay -Syu --needed cuda cudnn
fi

# clock
if ! [ -x "$(command -v ntpd)" ]; then
  yay -Syu --needed ntp
  sudo systemctl enable ntpd
  sudo systemctl start ntpd
fi

# spotify ad block
if ! [ -x "$(command -v spotify)" ] || ! [ -d /opt/spotify-ad-block ]; then
  cd /opt
  rm -rf spotify-ad-block
  sudo git clone https://github.com/x0uid/SpotifyAdBlock spotify-ad-block
  cd -
  cd /opt/spotify-ad-block
  cat hosts | sudo tee -a /etc/hosts
  cd -
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
    libxdamage libxfixes libxrandr libxrender mesa-libgl alsa-lib libglvnd
  rm -rf conda_install.sh
  wget "$conda_link" -O conda_install.sh
  chmod +x conda_install.sh
  ./conda_install.sh
  rm -rf conda_install.sh
fi

# update conda
# hard to update python version
# see https://stackoverflow.com/a/42104196
conda update anaconda
conda update -n base conda
conda update --all

# increase page watchers
# from https://gist.github.com/joseluisq/7f60f51b4570acac4a2ab5cecef31daa
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/50-max-user-watches.conf && sudo sysctl --system

# add awesome vim
# https://github.com/amix/vimrc
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

