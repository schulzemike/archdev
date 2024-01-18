#!/bin/bash
packages=(
  base-devel
  git
  man-db
  man-pages
  neovim
  pkgfile
  xclip
  xorg-apps
  xorg-server
)

echo -e "\n######################################################"
echo "Activating multilib mirrorlist and add arcolinux mirorlist"
id
sed -i -z "s/#\[multilib\]\n#/\[multilib\]\n/" /etc/pacman.conf


grep arcolinux_repo /etc/pacman.conf >/dev/null
if [[ $? != 0 ]]; then
cat <<EOT >> /etc/pacman.conf

[arcolinux_repo]
# SigLevel = Required DatabaseOptional
SigLevel = Optional TrustAll
Server = https://ftp.belnet.be/arcolinux/arcolinux_repo/x86_64

[arcolinux_repo_3party]
# SigLevel = Required DatabaseOptional
SigLevel = Optional TrustAll
Server = https://ftp.belnet.be/arcolinux/arcolinux_repo_3party/x86_64

[arcolinux_repo_xlarge]
# SigLevel = Required DatabaseOptional
SigLevel = Optional TrustAll
Server = https://ftp.belnet.be/arcolinux/arcolinux_repo_xlarge/x86_64
EOT
else
  echo "Arcolinux mirrors have already been added in the past"
fi
echo -e "\n################################################"
echo "Updating system..."
pacman -Syyu --noconfirm
pacman -S --noconfirm archlinux-keyring
if [ $? == 1 ]; then
  echo "An error occured while updating the keyring"
  exit 1
fi


pacman -Syu --noconfirm
if [ $? == 0 ]; then
  echo -e "System has been updated.\n"
else
  exit 1
fi

echo -e "\n######################################################"
echo "Installing base packages ..."
sudo pacman -S --noconfirm --needed "${packages[@]}"

echo -e "base packages have been installed.\n"
