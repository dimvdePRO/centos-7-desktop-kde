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
cat $CWD/config/bash/bashrc-root > /root/.bashrc
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration de Bash pour les utilisateurs..."
echo "::"
sleep $DELAY
cat $CWD/config/bash/bashrc-users > /etc/skel/.bashrc
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration de Vim..."
echo "::"
sleep $DELAY
cat $CWD/config/vim/vimrc > /etc/vimrc
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration des dépôts de base..."
echo "::"
sleep $DELAY
cat $CWD/config/yum/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Configuration du dépôt CR..."
echo "::"
sleep $DELAY
cat $CWD/config/yum/CentOS-CR.repo > /etc/yum.repos.d/CentOS-CR.repo
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
  rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 1> /dev/null
  yum -y install epel-release 1> /dev/null
  cat $CWD/config/yum/epel.repo > /etc/yum.repos.d/epel.repo
  cat $CWD/config/yum/epel-testing.repo > /etc/yum.repos.d/epel-testing.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q nux-dextop-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt Nux-Dextop..."
  echo "::"
  yum -y localinstall $CWD/config/yum/nux-dextop-release-*.rpm 1> /dev/null
  cat $CWD/config/yum/nux-dextop.repo > /etc/yum.repos.d/nux-dextop.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q adobe-release-x86_64 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt Adobe..."
  echo "::"
  yum -y localinstall $CWD/yum/adobe-release-*.rpm 1> /dev/null
  cat $CWD/config/yum/adobe-linux-x86_64.repo > /etc/yum.repos.d/adobe-linux-x86_64.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

if ! rpm -q elrepo-release 2>&1 > /dev/null ; then
  echo ":: Configuration du dépôt ELRepo."
  echo "::"
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org 1> /dev/null
  yum -y localinstall $CWD/yum/elrepo-release-*.rpm 1> /dev/null
  cat $CWD/config/yum/elrepo.repo > /etc/yum.repos.d/elrepo.repo
  echo -e ":: [${VERT}OK${GRIS}]"
  echo "::"
  sleep $DELAY
fi

echo ":: Synchronisation des dépôts de paquets..."
echo "::"
yum check-update 1> /dev/null
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Installation des outils Linux..."
echo "::"
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/outils-linux.txt)
yum -y install $PAQUETS 1> /dev/null
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo ":: Suppression des paquets inutiles..."
echo "::"
CHOLESTEROL=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/cholesterol.txt)
yum -y remove $CHOLESTEROL > /dev/null 2>&1
echo -e ":: [${VERT}OK${GRIS}]"
echo "::"
sleep $DELAY

echo

exit 0
