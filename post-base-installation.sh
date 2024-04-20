#!/usr/bin/bash

sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/&\nILoveCandy/' /etc/pacman.conf

printf '%s\n' "Getting my dotfiles."
git clone https://github.com/xtokyonight/dotfiles.git ~/.dotfiles \
  && cd .dotfiles/ && stow .

cd ~

sudo pacman -Syu --needed \
  git libxft libxinerama vim wget xorg-xrandr sxhkd \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-liberation \
  ttf-fira-code ttf-font-awesome ttf-jetbrains-mono ttf-nerd-fonts-symbols \
  qutebrowser firefox imv nsxiv \
  imagemagick flameshot maim obs-studio audacity \
  pavucontrol mpd cmus ncmpcpp ffmpeg mpv kdenlive handbrake handbrake-cli \
  mat2 mediainfo \
  kdeconnect android-file-transfer android-tools \
  zsh kitty tmux lf nnn trash-cli borg rsync syncthing \
  zip unzip dosfstools exfatprogs ntfs-3g udiskie \
  htop neofetch man-db man-pages polkit-kde-agent \
  libreoffice-fresh zathura zathura-pdf-mupdf zathura-djvu \
  aria2 python python-pip shellcheck checkbashisms libnotify dunst \
  redshift screenkey xwallpaper xdotool xclip xsel xcompmgr pass \
  bash-completion xdg-user-dirs npm ripgrep fd discord \
  openrgb gimp qbittorrent exa 

xdg-user-dirs-update
sudo npm install -g npm

# Installing python tools/programs
python3 -m pip install -U --user wheel
python3 -m pip install -U --user pywal dbus-python yt-dlp

fc-cache -fv

# dwm
git clone https://git.suckless.org/dwm $HOME/suckless/dwm
sudo make clean install --directory=$HOME/suckless/dwm

# dmenu
git clone https://git.suckless.org/dmenu $HOME/suckless/dmenu
sudo make clean install --directory=$HOME/suckless/dmenu

# st
git clone https://git.suckless.org/st $HOME/suckless/st
sudo make clean install --directory=$HOME/suckless/st

# slock
git clone https://git.suckless.org/slock $HOME/suckless/slock
sudo make clean install --directory=$HOME/suckless/slock

# slstatus
git clone https://git.suckless.org/slstatus $HOME/suckless/slstatus
sudo make clean install --directory=$HOME/suckless/slstatus

# xbanish
git clone https://github.com/jcs/xbanish.git $HOME/suckless/xbanish
sudo make clean install --directory=$HOME/suckless/xbanish

# grabc
git clone https://github.com/muquit/grabc.git $HOME/suckless/grabc
make --directory=$HOME/suckless/grabc
sudo make install --directory=$HOME/suckless/grabc

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# ani-cli
cd
git clone --depth 1 https://github.com/pystardust/ani-cli.git
sudo cp ani-cli/ani-cli /usr/local/bin
rm -rf ani-cli

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

