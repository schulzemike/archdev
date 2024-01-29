#!/bin/bash
echo
echo "###################################################################"
echo
echo "Installing tools"
echo

packages=(
  docker
  docker-compose
  jq
  keepassxc
  # libreoffice-still
  task
)

aur_packages=(
  google-chrome 
  jetbrains-toolbox
  noto-fonts-emoji
)



echo -e "\n###################################################################"
echo "Installing packages"
/usr/bin/pacman -S --noconfirm --needed "${packages[@]}"

echo -e "\n###################################################################"
echo "Installing aur packages"
pikaur -S --noconfirm --needed "${aur_packages[@]}"