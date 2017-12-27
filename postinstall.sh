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
  echo ":: Installation du plugin Yum-Priorities."
  yum -y install yum-plugin-priorities
fi

if ! rpm -q epel-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt EPEL."
  yum -y install epel-release
  cat $CWD/yum/epel.repo > /etc/yum.repos.d/epel.repo
  cat $CWD/yum/epel-testing.repo > /etc/yum.repos.d/epel-testing.repo
fi

if ! rpm -q nux-dextop-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt Nux-Dextop."
  cat $CWD/yum/nux-dextop.repo > /etc/yum.repos.d/nux-dextop.repo
fi

if ! rpm -q adobe-release-x86_64 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt Adobe."
  yum -y localinstall $CWD/yum/adobe-release-*.rpm
  cat $CWD/yum/adobe-linux-x86_64.repo > /etc/yum.repos.d/adobe-linux-x86_64.repo
fi

if ! rpm -q elrepo-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt ELRepo."
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
  yum -y localinstall $CWD/yum/elrepo-release-*.rpm
  cat $CWD/yum/elrepo.repo > /etc/yum.repos.d/elrepo.repo
fi

exit 0
