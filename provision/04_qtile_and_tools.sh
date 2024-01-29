#!/bin/bash

source /vagrant/provision/helper.sh

echo
echo "###################################################################"
echo
echo "Installing xorg, qtile and sddm"
echo
USER_PERMISSIONS="mike:mike"



function downloadNerdFont() {

    NERD_FONTS_VERSION="v3.1.1"
	SYSTEM_FONT_DIR="/usr/local/share/fonts"
	
	if [[ $# -ne 1 ]]; then
		echo "Provide the name of the font" >&2
		exit 1
	fi

	createDirIfNotExist $SYSTEM_FONT_DIR
	
	FONT=$1
		
	if [[ ! -d $SYSTEM_FONT_DIR/$FONT ]]; then
		wget -q -O /tmp/$FONT.zip https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$FONT.zip && unzip -q -d $SYSTEM_FONT_DIR/$FONT /tmp/$FONT.zip && rm /tmp/$FONT.zip
		if [[ $? -ne 0 ]]; then
			echo "Could not download the font: $FONT" >&2
			exit 1
		fi
		echo "Successfully installed the font: $FONT"
	fi
	return 0
}



pacman -R --noconfirm virtualbox-guest-utils-nox 2>/dev/null

packages=(
  alacritty
  dex
  # imageviewer
  feh
  mypy
  neofetch
  # polkit authentication agent is required for archlinux-logout app
  polkit
  qtile
  sddm
  starship
  sxhkd
  ttf-dejavu
  unzip
  virtualbox-guest-utils
  wget
  xclip
  xorg-apps
  xorg-server
)

aur_packages=(
  archlinux-logout-git
  arcolinux-wallpapers-git
  qtile-extras
  sddm-theme-tokyo-night
)
echo -e "\n###################################################################"
echo "Installing packages"
/usr/bin/pacman -S --noconfirm --needed "${packages[@]}"

echo -e "\n###################################################################"
echo "Installing aur packages"
# trust the gpg key of the qtile-extras provider
gpg --homedir /etc/pacman.d/gnupg/ --recv-keys 58A9AA7C86727DF7
pikaur -S --noconfirm --needed "${aur_packages[@]}"

#
# Virtualbox Guest Additions 
# see: https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest
#
usr/bin/systemctl enable vboxservice



#
# SDDM
#
echo -e "\nInstalling and configuring sddm"

/usr/bin/systemctl enable sddm
SDDM_CONF_DIR=/etc/sddm.conf.d

createDirIfNotExist $SDDM_CONF_DIR

# only set the new SDDM them if the conf-file has not yet been created
if [[ ! -f $SDDM_CONF_DIR/custom.conf ]]; then
  $SDDM_CONF_DIR/custom.conf
  echo "[Theme]" > $SDDM_CONF_DIR/custom.conf
  echo "Current=tokyo-night-sddm" >> $SDDM_CONF_DIR/custom.conf
  
  # copy the theme adjustments
  cp /vagrant/config/theme.conf.user /usr/share/sddm/themes/tokyo-night-sddm/
fi


#
# qtile adjustments
#

# remove the wayland session from the sddm launcher
rm /usr/share/wayland-sessions/qtile-wayland.desktop 2>/dev/null

# start qtile with a custom config. the standard config will be used in case the custom one is broken (while editing)
sed -i -z "s/qtile start\n/qtile start -c \".config\/qtile\/myconfig.py\"\n/" /usr/share/xsessions/qtile.desktop


#
# Language settings
#
echo LANG=de_DE.UTF-8 > /etc/locale.conf
echo KEYMAP=de-latin1 > /etc/vconsole.conf
rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
localectl set-keymap de-latin1


#
# Fonts
#
downloadNerdFont "JetBrainsMono"
downloadNerdFont "Noto"


#
# Bash relevant packages
#
/usr/bin/pacman -S --noconfirm --needed bash-completion


#
# Rofi Launcher
#
/usr/bin/pacman -S --noconfirm --needed rofi
ROFI_CONFIG_DIR="/home/mike/.config/rofi"
if [[ ! -d $ROFI_CONFIG_DIR ]]; then
    mkdir $ROFI_CONFIG_DIR
	rofi -dump-config > $ROFI_CONFIG_DIR/config.rasi
	chown -R $USER_PERMISSIONS $ROFI_CONFIG_DIR
fi
sed -i -z "s/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/" /etc/locale.gen
locale-gen


