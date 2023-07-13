#!/bin/zsh

#part1
clear
lsblk
echo "Enter the drive, e.g. /dev/sda :"
read -r drive

echo -n mem > /sys/power/state
hdparm --user-master u --security-set-pass p "$drive"
hdparm --user-master u --security-erase-enhanced p "$drive"

cfdisk "$drive"
echo "Enter Linux x86-64 root partition, e.g. /dev/sda3 :"
read -r root_partition ; mkfs.ext4 "$root_partition"
echo "Enter the Linux swap partiton, e.g. /dev/sda2 :"
read -r swap_partition ; mkswap "$swap_partition"
echo "Enter the EFI system partition, e.g. /dev/sda1 :"
read -r efi_system_partition ; mkfs.fat -F 32 "$efi_system_partition"

mount "$root_partition" /mnt
mount --mkdir "$efi_system_partition" /mnt/boot
swapon "$swap_partition"

echo "Server = http://mirror.xeonbd.com/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
printf '%s\n' "Enabling parallel downloads and updating keyring"
sed -i "s/^#ParallelDownloads = 5/ParallelDownloads = 10/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode xf86-video-ati man-db man-pages
genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#part2$/d' $(basename "$0") > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
rm -rf /mnt/arch_install2.sh

exit

#part2
printf '\033c'
sed -i 's/^#Color/Color/' /etc/pacman.conf
sed -i 's/^#CheckSpace/CheckSpace/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i 's/^ParallelDownloads = 10/&\nILoveCandy/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Syu

ln -sf /usr/share/zoneinfo/Asia/Dhaka /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen ; echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "Enter hostname: " ; read -r hostname
echo "$hostname" > /etc/hostname
{
echo "127.0.0.1       localhost"
echo "::1             localhost"
echo "127.0.1.1       $hostname"
} >> /etc/hosts
echo "Enter root/superuser password:" ; passwd

pacman -S --noconfirm --needed \
  neovim git stow zsh rsync \
  grub efibootmgr networkmanager dhcpcd udiskie

systemctl enable NetworkManager
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
echo "Enter username:" ; read -r username
useradd -m -G wheel -s /usr/bin/zsh "$username" ; passwd "$username"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
rm -rf $ai3_path
printf '%s\n' "Pre-Installation Finish Reboot now"
exit

#part3
cd ~
mkdir -p ~/.config ~/.local/state/bash ~/.local/state/zsh \
  ~/.local/state/mpd/playlists ~/.local/state/ncmpcpp ~/.cache ~/.vim/undo

printf '%s\n' "Getting my dotfiles."
git clone https://github.com/xtokyonight/dotfiles.git ~/.dotfiles \
  && cd .dotfiles/ && stow .

cd ~
rm -f .gitignore

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install sccache
{
echo "[build]"
echo 'rustc-wrapper = "sccache"'
} >> ~/.cargo/config

cargo install cargo-info
cargo install paru

printf '%s\n' "Setting up yay."
git clone --depth 1 https://aur.archlinux.org/yay.git ~/.local/src/yay \
  && cd ~/.local/src/yay && makepkg -si --noconfirm && cd ~

printf '%s\n' "Installing fonts."
sudo pacman -S --noconfirm --needed \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
  ttf-jetbrains-mono-nerd

printf '%s\n' "Installing audio & video related packages."
sudo pacman -S --noconfirm --needed \
  ffmpeg pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
  mpv mpd ncmpcpp pamixer playerctl alsa-utils pulsemixer obs-studio

# Hyprland
sudo pacman -S --noconfirm --needed \
  hyprland foot mako xdg-desktop-portal-hyprland polkit-kde-agent qt5-wayland qt6-wayland glfw-wayland \
  imv grim slurp gifsicle \
  spotify-launcher xorg-xlsclients

# AUR packages
yay -S \
  anki swww-git hyprpicker-git kickoff tofi shellcheck-bin topgrade

sudo pacman -S --noconfirm --needed \
  wget aria2 tmux \
  python python-pip imagemagick wl-clipboard \
  zip unzip unrar dosfstools exfatprogs ntfs-3g \
  checkbashisms libnotify \
  redshift neofetch firefox chromium \
  pass trash-cli exa bat zellij lazygit \
  bash-completion xdg-user-dirs npm ripgrep fd nnn lf discord yt-dlp

printf '%s\n' "Setting up Android packages."
sudo pacman -S --noconfirm --needed \
    android-file-transfer android-tools syncthing

xdg-user-dirs-update

sudo npm install -g npm

cd ~
fc-cache -fv
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

exit
