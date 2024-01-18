#!/bin/bash
echo
echo "###################################################################"
echo
echo "Installing qtile and sddm"
echo
USER_PERMISSIONS="mike:mike"
NERD_FONTS_VERSION="v3.1.1"

pacman -R --noconfirm virtualbox-guest-utils-nox 2>/dev/null

packages=(
  alacritty
  autorandr
  neofetch
  qtile
  sddm
  sxhkd
  ttf-dejavu
  unzip
  virtualbox-guest-utils
  wget
)

aur_packages=(
  sddm-theme-tokyo-night
  archlinux-logout-git
)
echo "###################################################################"
echo "Installing packages"
/usr/bin/pacman -S --noconfirm --needed "${packages[@]}"

echo "###################################################################"
echo "Installing aur packages"
pikaur -S --noconfirm --needed "${aur_packages[@]}"


echo -e "\nInstalling and configuring sddm"
# SDDM
/usr/bin/systemctl enable sddm
SDDM_CONF_DIR=/etc/sddm.conf.d
if [ ! -d $SDDM_CONF_DIR ]; then
  mkdir $SDDM_CONF_DIR
fi
# only set the new SDDM them if the conf-file has not yet been created
if [ ! -f $SDDM_CONF_DIR/custom.conf ]; then
  $SDDM_CONF_DIR/custom.conf
  echo "[Theme]" > $SDDM_CONF_DIR/custom.conf
  echo "Current=tokyo-night-sddm" >> $SDDM_CONF_DIR/custom.conf
  
  # copy the theme adjustments
  cp /vagrant/config/theme.conf.user /usr/share/sddm/themes/tokyo-night-sddm/
fi

# qtile adjustments
#
# remove the wayland session from the sddm launcher
rm /usr/share/wayland-sessions/qtile-wayland.desktop 2>/dev/null

# start qtile with a custom config. the standard config will be used in case the custom one is broken (while editing)
sed -i -z "s/qtile start\n/qtile start -c \".config\/qtile\/myconfig.py\"\n/" /usr/share/xsessions/qtile.desktop



# Spracheinstellungen
echo LANG=de_DE.UTF-8 > /etc/locale.conf
echo KEYMAP=de-latin1 > /etc/vconsole.conf
rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
localectl set-keymap de-latin1
# localectl --no-convert set-x11-keymap de pc105

# Fonts
if [ ! -d /usr/local/share/fonts ]; then
    mkdir /usr/local/share/fonts
fi

if [ ! -d /usr/local/share/fonts/JetBrainsMono ]; then
    wget -q -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/JetBrainsMono.zip && unzip -q -d /usr/local/share/fonts/JetBrainsMono /tmp/JetBrainsMono.zip && rm /tmp/JetBrainsMono.zip
fi

# Bash relevant packages
/usr/bin/pacman -S --noconfirm --needed bash-completion



# Rofi Launcher
/usr/bin/pacman -S --noconfirm --needed rofi
ROFI_CONFIG_DIR="/home/mike/.config/rofi"
if [ ! -d $ROFI_CONFIG_DIR ]; then
    mkdir $ROFI_CONFIG_DIR
	rofi -dump-config > $ROFI_CONFIG_DIR/config.rasi
	chown -R $USER_PERMISSIONS $ROFI_CONFIG_DIR
fi


# Browser
/usr/bin/pikaur -Syu --noconfirm --needed google-chrome noto-fonts-emoji

