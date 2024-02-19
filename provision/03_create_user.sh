#!/bin/bash
echo -e "\n###################################################################"
echo
echo "Creating user"
echo
USER_NAME="mike"
FULL_NAME="Mike Schulze"
EMAIL="schulze.mike@gmx.net"

HOME_DIR="/home/$USER_NAME"
RSA_KEY="$HOME_DIR/.ssh/id-github_rsa"

DOTFILES_REPO="git@github.com:schulzemike/my-dotfiles.git"


if id $USER_NAME >/dev/null 2>&1; then
    echo "User $USER_NAME has already been created"
else 
    /usr/bin/useradd --create-home --user-group $USER_NAME
    echo -e 'changeme\nchangeme' | /usr/bin/passwd $USER_NAME
	
	echo "$USER_NAME ALL=(ALL) ALL" >> /etc/sudoers.d/10_$USER_NAME
	mkdir $HOME_DIR/.ssh

    # echo "Creating GitHub RSA Key..."
	# /usr/bin/ssh-keygen -t ed25519 -C $EMAIL -f $RSA_KEY -N ""
	
	echo "Using provided GitHub RSA Key..."
	cp /vagrant/ssh/id-github_rsa $RSA_KEY
	chmod 600 $RSA_KEY
	
	echo -e "Host github.com\n    IdentityFile $RSA_KEY" >> $HOME_DIR/.ssh/config
	/usr/bin/ssh-keyscan github.com >> $HOME_DIR/.ssh/known_hosts
	chown -R $USER_NAME:$USER_NAME $HOME_DIR/.ssh
	chmod 700 $HOME_DIR/.ssh
	
	mkdir $HOME_DIR/projekte
	chown -R $USER_NAME:$USER_NAME $HOME_DIR/projekte
	
	echo "Finished creating user: $USER_NAME"
fi 

# Initialize the .dotfiles repo as the created user - see: https://wiki.archlinux.org/title/Dotfiles
GIT_DIR=$HOME_DIR/.dotfiles

if [[ ! -d $GIT_DIR ]]; then
	su -c "/usr/bin/git init --initial-branch=main --bare $GIT_DIR" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR config status.showUntrackedFiles no" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR config user.email $EMAIL" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR config user.name $FULL_NAME" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR remote add origin $DOTFILES_REPO" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR fetch" $USER_NAME
    su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR checkout main --force" $USER_NAME
fi

echo -e "Finished creating the user\n"
