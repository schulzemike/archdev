#!/bin/bash
source /vagrant/provision/helper.sh

USER=mike
USER_HOME=/home/$USER

TF_DOCS_VERSION="0.17.0"

echo
echo
echo "#######################################################################"
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
  terraform
)

aur_packages=(
  google-cloud-cli
  google-cloud-cli-gke-gcloud-auth-plugin
  google-chrome 
  jetbrains-toolbox
  noto-fonts-emoji
  nvm
)

createDirIfNotExist $USER_HOME/.local/share/JetBrains
createDirIfNotExist $USER_HOME/.local/share/JetBrains/Toolbox/apps
createDirIfNotExist $USER_HOME/.local/share/JetBrains/Toolbox/scripts
chown -R $USER:$USER $USER_HOME/.local/share/JetBrains

echo
echo
echo "#######################################################################"
echo "Installing packages"
/usr/bin/pacman -S --noconfirm --needed "${packages[@]}"

echo
echo
echo "#######################################################################"
echo "Installing aur packages"
pikaur -S --noconfirm --needed "${aur_packages[@]}"



echo
echo
echo "#######################################################################"
echo "Configuring docker"
/usr/bin/systemctl enable docker.service
sudo usermod -aG docker $USER


echo
echo
echo "#######################################################################"
echo "Installing terraform docs in Version ${TF_DOCS_VERSION}"
echo "see: https://github.com/terraform-docs/terraform-docs/releases"
echo

terraform-docs -v | grep $TF_DOCS_VERSION > /dev/null
if [[ $? != 0 ]]; then
	curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TF_DOCS_VERSION}/terraform-docs-v${TF_DOCS_VERSION}-linux-amd64.tar.gz
	tar -xzf terraform-docs.tar.gz
	chmod +x terraform-docs
	mv terraform-docs /usr/local/bin/terraform-docs
	rm terraform-docs.tar.gz
	echo "Terraform-docs has been installed successfully."
else
	echo "Terraform-docs has already been installed in version ${TF_DOCS_VERSION}"
fi
