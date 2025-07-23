#!/usr/bin/bash

clear
cd
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/&\nILoveCandy/' /etc/pacman.conf
sudo pacman -Syu

# install AUR helper
printf '%s\n' "Installing yay"
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

printf '%s\n' "Installing dwm"
sudo pacman -S --noconfirm --needed libxft libxinerama
git clone https://git.suckless.org/dwm $HOME/suckless/dwm
#git clone https://github.com/xtokyonight/dwm.git $HOME/suckless/dwm
cp $HOME/suckless/dwm/config.def.h $HOME/suckless/dwm/config.h
sudo make install clean --directory=$HOME/suckless/dwm

# dmenu
printf '%s\n' "Installing dmenu"
git clone https://git.suckless.org/dmenu $HOME/suckless/dmenu
cp $HOME/suckless/dmenu/config.def.h $HOME/suckless/dmenu/config.h
sudo make install clean --directory=$HOME/suckless/dmenu

# st
printf '%s\n' "Installing st"
git clone https://git.suckless.org/st $HOME/suckless/st
#git clone https://github.com/xtokyonight/st.git $HOME/suckless/st
cp $HOME/suckless/st/config.def.h $HOME/suckless/st/config.h
sudo make install clean --directory=$HOME/suckless/st

# slock
printf '%s\n' "Installing slock"
git clone https://git.suckless.org/slock $HOME/suckless/slock
#git clone https://github.com/xtokyonight/slock.git $HOME/suckless/slock
cp $HOME/suckless/slock/config.def.h $HOME/suckless/slock/config.h
sed -i 's/nogroup/nobody/' $HOME/suckless/slock/config.h
sudo make install clean --directory=$HOME/suckless/slock

# slstatus
printf '%s\n' "Installing slstatus"
#git clone https://git.suckless.org/slstatus $HOME/suckless/slstatus
git clone https://github.com/xtokyonight/slstatus.git $HOME/suckless/slstatus
sudo make install clean --directory=$HOME/suckless/slstatus

# install fonts
yay -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra getnf

printf '%s\n' "Getting my dotfiles."
sudo pacman -S stow
git clone https://github.com/xtokyonight/dotfiles.git ~/.dotfiles \
  && cd .dotfiles && stow . && cd

sudo pacman -S --needed \
  github-cli neovim emacs zellij wget xorg-xrandr sxhkd \
  qutebrowser python-adblock firefox imv nsxiv xwallpaper xcompmgr xclip \
  imagemagick flameshot maim obs-studio audacity \
  pavucontrol cmus ffmpeg mpv mat2 mediainfo \
  kdeconnect android-file-transfer android-tools \
  zsh kitty tmux lf nnn trash-cli borg rsync syncthing \
  zip unzip dosfstools exfatprogs ntfs-3g udiskie \
  htop fastfetch man-db man-pages polkit-kde-agent \
  libreoffice-fresh zathura zathura-pdf-poppler \
  aria2 python python-pip shellcheck checkbashisms libnotify dunst \
  screenkey xdotool xsel pass yt-dlp \
  bash-completion xdg-user-dirs xdg-utils ripgrep fd discord \
  openrgb gimp qbittorrent exa alsa-utils

yay -S shellcheck-bin
xdg-user-dirs-update
fc-cache -fv

# lf previewing
yay -S ctpv-git ueberzugpp bat ffmpegthumbnailer

# Set default applications with xdg-mime
xdg-mime default nsxiv.desktop image/png
xdg-mime default nsxiv.desktop image/jpeg
xdg-mime default nsxiv.desktop image/gif
xdg-mime default org.pwmt.zathura.desktop application/pdf

# xbanish
printf '%s\n' "Installing xbanish"
git clone https://github.com/jcs/xbanish.git $HOME/suckless/xbanish
sudo make clean install --directory=$HOME/suckless/xbanish

# grabc
printf '%s\n' "Installing grabc"
git clone https://github.com/muquit/grabc.git $HOME/suckless/grabc
make --directory=$HOME/suckless/grabc
sudo make install --directory=$HOME/suckless/grabc

# ani-cli
printf '%s\n' "Installing ani-cli"
cd
git clone --depth 1 https://github.com/pystardust/ani-cli.git
sudo cp ani-cli/ani-cli /usr/local/bin
rm -rf ani-cli

# fzf
printf '%s\n' "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# for screenshotting purposes
# flameshot - opensource screenshot software
# maim - maim (Make Image) is an utility that takes screenshots of your desktop. It's meant to overcome shortcomings of scrot and performs better in several ways.
# xclip - to copy screenshot to clipboard
# xdotool - to get active window and screenshot it using maim

