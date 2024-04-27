#!/usr/bin/bash

clear
cd "$HOME" || exit
sudo pacman -Syu

# AUR
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/&\nILoveCandy/' /etc/pacman.conf

printf '%s\n' "Getting my dotfiles."
git clone https://github.com/xtokyonight/dotfiles.git ~/.dotfiles \
  && cd .dotfiles && stow . && cd "$HOME"

printf '%s\n' "Installing neovim and it's dependencies for kickstart.nvim config"
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
printf '%s\n' "Getting my kickstart.nvim config"
git clone https://github.com/xtokyonight/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

sudo pacman -S --needed \
  git github-cli libxft libxinerama neovim zellij wget xorg-xrandr sxhkd \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-liberation \
  ttf-fira-code ttf-font-awesome ttf-jetbrains-mono ttf-nerd-fonts-symbols \
  qutebrowser python-adblock firefox imv nsxiv xwallpaper xcompmgr xclip \
  imagemagick flameshot maim obs-studio audacity \
  pavucontrol cmus ffmpeg mpv mat2 mediainfo \
  kdeconnect android-file-transfer android-tools \
  zsh kitty tmux lf nnn trash-cli borg rsync syncthing \
  zip unzip dosfstools exfatprogs ntfs-3g udiskie \
  htop neofetch man-db man-pages polkit-kde-agent \
  libreoffice-fresh zathura zathura-pdf-poppler \
  aria2 python python-pip shellcheck checkbashisms libnotify dunst \
  screenkey xdotool xsel pass yt-dlp \
  bash-completion xdg-user-dirs xdg-utils ripgrep fd discord \
  openrgb gimp qbittorrent exa 

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

# dwm
#git clone https://git.suckless.org/dwm $HOME/suckless/dwm
git clone https://github.com/xtokyonight/dwm.git $HOME/suckless/dwm
sudo make clean install --directory=$HOME/suckless/dwm

# dmenu
git clone https://git.suckless.org/dmenu $HOME/suckless/dmenu
sudo make clean install --directory=$HOME/suckless/dmenu

# st
#git clone https://git.suckless.org/st $HOME/suckless/st
git clone https://github.com/xtokyonight/st.git $HOME/suckless/st
sudo make clean install --directory=$HOME/suckless/st

# slock
#git clone https://git.suckless.org/slock $HOME/suckless/slock
git clone https://github.com/xtokyonight/slock.git $HOME/suckless/slock
sudo make clean install --directory=$HOME/suckless/slock

# slstatus
#git clone https://git.suckless.org/slstatus $HOME/suckless/slstatus
git clone https://github.com/xtokyonight/slstatus.git $HOME/suckless/slstatus
sudo make clean install --directory=$HOME/suckless/slstatus

# xbanish
git clone https://github.com/jcs/xbanish.git $HOME/suckless/xbanish
sudo make clean install --directory=$HOME/suckless/xbanish

# grabc
git clone https://github.com/muquit/grabc.git $HOME/suckless/grabc
make --directory=$HOME/suckless/grabc
sudo make install --directory=$HOME/suckless/grabc

# ani-cli
cd
git clone --depth 1 https://github.com/pystardust/ani-cli.git
sudo cp ani-cli/ani-cli /usr/local/bin
rm -rf ani-cli

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# sudo pacman -S --needed base-devel
# git clone https://aur.archlinux.org/paru.git
# cd paru
# makepkg -si
