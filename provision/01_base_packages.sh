#!/bin/bash

source /vagrant/provision/helper.sh
echo
echo
echo "#######################################################################"
echo "Adding public key for future ssh access"
echo 

createDirIfNotExist /home/vagrant/.ssh
cp /vagrant/vagrant-ssh/authorized_keys /home/vagrant/.ssh
cp /vagrant/vagrant-ssh/id_rsa.pub /home/vagrant/.ssh
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa.pub
chmod 644 /home/vagrant/.ssh/id_rsa.pub

echo "public ssh key added"


packages=(
  base-devel
  git
  man-db
  man-pages
  neovim
  pkgfile
  procps-ng
)


echo
echo
echo "#######################################################################"
echo "Activating multilib mirrorlist and add arcolinux mirorlist"
echo


sed -i -z "s/#\[multilib\]\n#/\[multilib\]\n/" /etc/pacman.conf
sed -i -z "s/#Color\n/Color\n/" /etc/pacman.conf
sed -i -z "s/#ParallelDownloads = 5/ParallelDownloads = 5/" /etc/pacman.conf

grep arcolinux_repo /etc/pacman.conf >/dev/null
if [[ $? -ne 0 ]]; then
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


echo
echo
echo "#######################################################################"
echo "Updating system..."
echo
pacman -Sy --noconfirm archlinux-keyring && pacman -Su --noconfirm
if [ $? == 1 ]; then
  echo "An error occured while updating the keyring or during the system update"
  exit 1
fi
echo "System has been updated."


echo
echo
echo "#######################################################################"
echo "Installing base packages ..."
echo
sudo pacman -S --noconfirm --needed "${packages[@]}"
echo "base packages have been installed."
