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

if ! rpm -q yum-plugin-priorities 2>&1 > /dev/null ; then
  yum -y install yum-plugin-priorities
fi

if ! rpm -q epel-release 2>&1 > /dev/null ; then
  yum -y install epel-release
fi

echo ":: Configuration du dépôt EPEL."
cat $CWD/yum/epel.repo > /etc/yum.repos.d/epel.repo
cat $CWD/yum/epel-testing.repo > /etc/yum.repos.d/epel-testing.repo

exit 0
