#!/bin/bash
#
# postinstall.sh
#
# Script post-installation pour CentOS 7 + KDE
#
# (c) Nicolas Kovacs, 2018

# Exécuter en tant que root
if [ $EUID -ne 0 ] ; then
  echo "::"
  echo ":: Vous devez être root pour exécuter ce script."
  echo "::"
  exit 1
fi

CWD=$(pwd)

# Quitter en cas d'erreur
set -e

# Couleurs
VERT="\033[01;32m"
GRIS="\033[00m"

# Journal
LOG=/tmp/postinstall.log

# Pause entre les opérations
DELAY=1

# Nettoyer le fichier journal
echo > $LOG

echo
echo "     ######################################" | tee -a $LOG
echo "     ### CentOS 7 KDE Post-installation ###" | tee -a $LOG
echo "     ######################################" | tee -a $LOG
echo | tee -a $LOG

echo -e ":: Mise à jour initiale du système... \c"
yum update >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Désactivation de l'IPv6... \c"
cat $CWD/config/sysctl.d/disable-ipv6.conf > /etc/sysctl.d/disable-ipv6.conf
if [ -f /etc/ssh/sshd_config ]; then
  sed -i -e 's/#AddressFamily any/AddressFamily inet/g' /etc/ssh/sshd_config
  sed -i -e 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
fi
yum update >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

exit 0

echo -e ":: Configuration de Bash pour l'administrateur... \c"
sleep $DELAY
cat $CWD/config/bash/bashrc-root > /root/.bashrc 
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Configuration de Bash pour les utilisateurs... \c"
sleep $DELAY
cat $CWD/config/bash/bashrc-users > /etc/skel/.bashrc
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Configuration de Vim... \c"
sleep $DELAY
cat $CWD/config/vim/vimrc > /etc/vimrc
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Configuration des dépôts de paquets officiels... \c"
sleep $DELAY
cat $CWD/config/yum/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
sed -i -e 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Configuration du dépôt de paquets CR... \c"
sleep $DELAY
cat $CWD/config/yum/CentOS-CR.repo > /etc/yum.repos.d/CentOS-CR.repo
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

if ! rpm -q yum-plugin-priorities 2>&1 > /dev/null ; then
  echo -e ":: Installation du plugin Yum-Priorities... \c"
  yum -y install yum-plugin-priorities >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

if ! rpm -q epel-release 2>&1 > /dev/null ; then
  echo -e ":: Configuration du dépôt de paquets EPEL... \c"
  rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 >> $LOG 2>&1
  yum -y install epel-release >> $LOG 2>&1
  cat $CWD/config/yum/epel.repo > /etc/yum.repos.d/epel.repo
  cat $CWD/config/yum/epel-testing.repo > /etc/yum.repos.d/epel-testing.repo
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

if ! rpm -q nux-dextop-release 2>&1 > /dev/null ; then
  echo -e ":: Configuration du dépôt de paquets Nux-Dextop... \c"
  yum -y localinstall $CWD/config/yum/nux-dextop-release-*.rpm >> $LOG 2>&1
  cat $CWD/config/yum/nux-dextop.repo > /etc/yum.repos.d/nux-dextop.repo
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

if ! rpm -q adobe-release-x86_64 2>&1 > /dev/null ; then
  echo -e ":: Configuration du dépôt de paquets Adobe... \c"
  yum -y localinstall $CWD/config/yum/adobe-release-*.rpm >> $LOG 2>&1
  cat $CWD/config/yum/adobe-linux-x86_64.repo > /etc/yum.repos.d/adobe-linux-x86_64.repo
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

if ! rpm -q elrepo-release 2>&1 > /dev/null ; then
  echo -e ":: Configuration du dépôt de paquets ELRepo... \c"
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org >> $LOG 2>&1
  yum -y localinstall $CWD/config/yum/elrepo-release-*.rpm >> $LOG 2>&1
  cat $CWD/config/yum/elrepo.repo > /etc/yum.repos.d/elrepo.repo
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

echo -e ":: Synchronisation des dépôts de paquets... \c"
yum check-update >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Installation des outils système Linux... \c"
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/outils-linux.txt)
yum -y install $PAQUETS >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Suppression des paquets inutiles... \c"
CHOLESTEROL=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/cholesterol.txt)
yum -y remove $CHOLESTEROL >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo -e ":: Installation des applications supplémentaires... \c"
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/bureau-kde.txt)
yum -y install $PAQUETS >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

echo

exit 0
