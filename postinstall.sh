#!/bin/bash
#
# postinstall.sh
#
# Script post-installation pour CentOS 7 + KDE
#
# (c) Nicolas Kovacs, 2018

CWD=$(pwd)

# Couleurs
VERT="\033[01;32m"
GRIS="\033[00m"

# Pause entre les opérations
DELAY=1

echo
echo "::"

echo ":: Configuration de Bash pour l'administrateur..."
echo "::"
sleep $DELAY
cat $CWD/bash/bashrc-root > /root/.bashrc
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration de Bash pour les utilisateurs..."
echo "::"
sleep $DELAY
cat $CWD/bash/bashrc-users > /etc/skel/.bashrc
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration de Vim..."
echo "::"
sleep $DELAY
cat $CWD/vim/vimrc > /etc/vimrc
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration des dépôts de base..."
echo "::"
sleep $DELAY
cat $CWD/yum/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration du dépôt CR..."
echo "::"
sleep $DELAY
cat $CWD/yum/CentOS-CR.repo > /etc/yum.repos.d/CentOS-CR.repo
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

if ! rpm -q yum-plugin-priorities 2>&1 > /dev/null ; then
  echo ":: Installation du plugin Yum-Priorities..."
  echo "::"
  yum -y install yum-plugin-priorities 1> /dev/null
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q epel-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt EPEL..."
  echo "::"
  yum -y install epel-release 1> /dev/null
  cat $CWD/yum/epel.repo > /etc/yum.repos.d/epel.repo
  cat $CWD/yum/epel-testing.repo > /etc/yum.repos.d/epel-testing.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q nux-dextop-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt Nux-Dextop..."
  echo "::"
  yum -y localinstall $CWD/yum/nux-dextop-release-*.rpm 1> /dev/null
  cat $CWD/yum/nux-dextop.repo > /etc/yum.repos.d/nux-dextop.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q adobe-release-x86_64 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt Adobe..."
  echo "::"
  yum -y localinstall $CWD/yum/adobe-release-*.rpm 1> /dev/null
  cat $CWD/yum/adobe-linux-x86_64.repo > /etc/yum.repos.d/adobe-linux-x86_64.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q elrepo-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt ELRepo."
  echo "::"
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org 1> /dev/null
  yum -y localinstall $CWD/yum/elrepo-release-*.rpm 1> /dev/null
  cat $CWD/yum/elrepo.repo > /etc/yum.repos.d/elrepo.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

exit 0
