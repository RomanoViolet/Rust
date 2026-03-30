#!/usr/bin/env bash

# Setup keys
sudo cp /host/.gitconfig $HOME/.gitconfig
sudo cp -rv /host/.ssh $HOME/
sudo chown -R $UID:$UID $HOME/.ssh
sudo chown -R $UID:$UID $HOME/.gitconfig

# Clean up imported .gitconfig
git config --global --unset credential.credentialStore
git config --global --unset-all credential.helper

# Configure Git Credential Manager
git-credential-manager configure
#git config --global credential.helper manager

git config --global --add credential.helper 'cache --timeout=36000'
git config --global credential.gui false
#git config --global credential.helper 'cache --timeout=36000'
