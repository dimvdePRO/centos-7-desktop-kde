#!/bin/bash
#
# postinstall.sh
#
# Script post-installation pour CentOS 7 + KDE
#
# (c) Nicolas Kovacs, 2018

CWD=$(pwd)

echo

echo ":: Configuration de Bash pour l'administrateur."
cat $CWD/bash/bashrc-root > /root/.bashrc

echo ":: Configuration de Bash pour les utilisateurs."
cat $CWD/bash/bashrc-users > /etc/skel/.bashrc

echo ":: Configuration de Vim."
cat $CWD/vim/vimrc > /etc/vimrc

echo ":: Configuration des dépôts de base."
cat $CWD/yum/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo

echo ":: Configuration du dépôt CR."
cat $CWD/yum/CentOS-CR.repo > /etc/yum.repos.d/CentOS-CR.repo

exit 0
