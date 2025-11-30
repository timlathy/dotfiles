#!/bin/bash

# Link dotfiles
mv ~/.bashrc ~/.bashrc.old
ln -s `pwd`/.bashrc ~/.bashrc

mv ~/.zshrc ~/.zshrc.old
ln -s `pwd`/.zshrc ~/.zshrc

mv ~/.vimrc ~/.vimrc.old
ln -s `pwd`/.vimrc ~/.vimrc

mv ~/.gdbinit ~/.gdbinit.old
ln -s `pwd`/.gdbinit ~/.gdbinit

mv ~/.radare2rc ~/.radare2rc.old
ln -s `pwd`/.radare2rc ~/.radare2rc

mkdir -p ~/.vim
ln -s `pwd`/plugins.vim ~/.vim/plugins.vim

ln -s `pwd`/gitignore_global ~/gitignore_global
git config --global core.excludesfile ~/gitignore_global

mkdir -p ~/.stack/global
ln -s `pwd`/stack.global.yaml ~/.stack/global/stack.yaml

mkdir -p ~/.config/Code/User
ln -s `pwd`/vscode/settings.json ~/.config/Code/User/settings.json
ln -s `pwd`/vscode/keybindings.json ~/.config/Code/User/keybindings.json

# Run Ansible
sudo dnf install -y ansible
ansible-galaxy collection install community.general
ansible-playbook bootstrap.yml -v --ask-become-pass
