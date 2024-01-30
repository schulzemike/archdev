#!/bin/bash
source /vagrant/provision/helper.sh

USER=mike
USER_HOME=/home/$USER

echo
echo "###################################################################"
echo
echo "Installing tools"
echo

packages=(
  docker
  docker-compose
  jq
  # libappindicator is required to display the trayicon of the jetbrains-toolbox
  libappindicator-gtk3
  keepassxc
  # libreoffice-still
  task
)

aur_packages=(
  google-chrome 
  jetbrains-toolbox
  noto-fonts-emoji
)

createDirIfNotExist $USER_HOME/.local/share/JetBrains/Toolbox/apps
chown $USER:$USER $USER_HOME/.local/share/JetBrains/Toolbox/apps
createDirIfNotExist $USER_HOME/.local/share/JetBrains/Toolbox/scripts
chown $USER:$USER $USER_HOME/.local/share/JetBrains/Toolbox/scripts

echo -e "\n###################################################################"
echo "Installing packages"
/usr/bin/pacman -S --noconfirm --needed "${packages[@]}"

echo -e "\n###################################################################"
echo "Installing aur packages"
pikaur -S --noconfirm --needed "${aur_packages[@]}"