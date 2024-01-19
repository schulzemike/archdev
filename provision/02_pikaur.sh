#!/bin/bash
# install pikaur - AUR helper

echo -e "\n################################################"
echo "Installing pikaur..."
which pikaur > /dev/null 2>&1 
if [[ $? -ne 0 ]]; then
  sudo -u vagrant /bin/bash <<EOF
    id
	git clone https://aur.archlinux.org/pikaur.git /tmp/pikaur
	cd /tmp/pikaur
	ls
	makepkg -fsri --noconfirm --needed
EOF

  rm -r /tmp/pikaur
  echo -e "pikaur has been installed.\n"
else
  echo -e "pikaur has already been installed.\n"
fi
