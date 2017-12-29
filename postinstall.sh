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

# Répertoire courant
CWD=$(pwd)

# Interrompre en cas d'erreur
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

# Bannière
echo
echo "     ######################################" | tee -a $LOG
echo "     ### CentOS 7 KDE Post-installation ###" | tee -a $LOG
echo "     ######################################" | tee -a $LOG
echo | tee -a $LOG

# Mise à jour initiale
echo -e ":: Mise à jour initiale du système... \c"
yum -y update >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Pour l'instant on n'utilise que l'IPv4
echo -e ":: Désactivation de l'IPv6... \c"
sleep $DELAY
cat $CWD/config/sysctl.d/disable-ipv6.conf > /etc/sysctl.d/disable-ipv6.conf
if [ -f /etc/ssh/sshd_config ]; then
  sed -i -e 's/#AddressFamily any/AddressFamily inet/g' /etc/ssh/sshd_config
  sed -i -e 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
fi
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Passer SELinux en mode permissif 
echo -e ":: Configuration de SELinux en mode permissif... \c"
sleep $DELAY
if [ -f /etc/selinux/config ]; then
  sed -i -e 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
  setenforce 0
fi
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Personnalisation du shell Bash pour root
echo -e ":: Configuration du shell Bash pour l'administrateur... \c"
sleep $DELAY
cat $CWD/config/bash/bashrc-root > /root/.bashrc 
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Personnalisation du shell Bash pour les utilisateurs
echo -e ":: Configuration du shell Bash pour les utilisateurs... \c"
sleep $DELAY
cat $CWD/config/bash/bashrc-users > /etc/skel/.bashrc
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Quelques options pratiques pour Vim
echo -e ":: Configuration de Vim... \c"
sleep $DELAY
cat $CWD/config/vim/vimrc > /etc/vimrc
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Activer les dépôts [base], [updates] et [extras] avec une priorité de 1
echo -e ":: Configuration des dépôts de paquets officiels... \c"
sleep $DELAY
cat $CWD/config/yum/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
sed -i -e 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Activer le dépôt [cr] avec une priorité de 1
echo -e ":: Configuration du dépôt de paquets CR... \c"
sleep $DELAY
cat $CWD/config/yum/CentOS-CR.repo > /etc/yum.repos.d/CentOS-CR.repo
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Installer le plugin Yum-Priorities
if ! rpm -q yum-plugin-priorities 2>&1 > /dev/null ; then
  echo -e ":: Installation du plugin Yum-Priorities... \c"
  yum -y install yum-plugin-priorities >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

# Activer le dépôt [epel] avec une priorité de 10
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

# Activer le dépôt [nux-dextop] avec une priorité de 10
if ! rpm -q nux-dextop-release 2>&1 > /dev/null ; then
  echo -e ":: Configuration du dépôt de paquets Nux-Dextop... \c"
  yum -y localinstall $CWD/config/yum/nux-dextop-release-*.rpm >> $LOG 2>&1
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-nux.ro >> $LOG 2>&1
  cat $CWD/config/yum/nux-dextop.repo > /etc/yum.repos.d/nux-dextop.repo
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

# Activer le dépôt [adobe-linux-x86_64] avec une priorité de 10
if ! rpm -q adobe-release-x86_64 2>&1 > /dev/null ; then
  echo -e ":: Configuration du dépôt de paquets Adobe... \c"
  yum -y localinstall $CWD/config/yum/adobe-release-*.rpm >> $LOG 2>&1
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux >> $LOG 2>&1
  cat $CWD/config/yum/adobe-linux-x86_64.repo > /etc/yum.repos.d/adobe-linux-x86_64.repo
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

# Configurer les dépôts [elrepo], [elrepo-kernel], etc. sans les activer
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

# Synchroniser les dépôts de paquets
echo -e ":: Synchronisation des dépôts de paquets... \c"
yum check-update >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Installer les outils Linux listés dans config/pkglists/outils-linux.txt
echo -e ":: Installation des outils système Linux... \c"
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/outils-linux.txt)
yum -y install $PAQUETS >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Supprimer les paquets inutiles listés dans config/pkglists/cholesterol.txt
echo -e ":: Suppression des paquets inutiles... \c"
CHOLESTEROL=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/cholesterol.txt)
yum -y remove $CHOLESTEROL >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Installer les paquets listés dans config/pkglists/bureau-kde.txt
echo -e ":: Installation des applications supplémentaires... \c"
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/config/pkglists/bureau-kde.txt)
yum -y install $PAQUETS >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Personnaliser les entrées du menu KDE
echo -e ":: Personnalisation des entrées de menu KDE... \c"
sleep $DELAY
$CWD/menus.sh >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Installer le profil par défaut des utilisateurs
echo -e ":: Installation du profil par défaut des utilisateurs... \c"
sleep $DELAY
$CWD/profil.sh >> $LOG 2>&1
echo -e "[${VERT}OK${GRIS}] \c"
sleep $DELAY
echo
echo "::"

# Installer les polices Apple
if [ ! -d /usr/share/fonts/apple-fonts ]; then
  cd /tmp
  rm -rf /usr/share/fonts/apple-fonts
  echo -e ":: Installation des polices TrueType Apple... \c"
  wget -c https://www.microlinux.fr/download/FontApple.tar.xz >> $LOG 2>&1
  mkdir /usr/share/fonts/apple-fonts
  tar xvf FontApple.tar.xz >> $LOG 2>&1
  mv Lucida*.ttf Monaco.ttf /usr/share/fonts/apple-fonts/
  fc-cache -f -v >> $LOG 2>&1
  cd - >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

# Installer la police Eurostile
if [ ! -d /usr/share/fonts/eurostile ]; then
  cd /tmp
  rm -rf /usr/share/fonts/eurostile
  echo -e ":: Installation de la police TrueType Eurostile... \c"
  wget -c https://www.microlinux.fr/download/Eurostile.zip >> $LOG 2>&1
  unzip Eurostile.zip -d /usr/share/fonts/ >> $LOG 2>&1
  mv /usr/share/fonts/Eurostile /usr/share/fonts/eurostile
  fc-cache -f -v >> $LOG 2>&1
  cd - >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

# Installer les fonds d'écran Microlinux
if [ ! -f /usr/share/backgrounds/.microlinux ]; then
  cd /tmp
  echo -e ":: Installation des fonds d'écran Microlinux... \c"
  wget -c https://www.microlinux.fr/download/microlinux-wallpapers.tar.gz >> $LOG 2>&1
  tar xvzf microlinux-wallpapers.tar.gz >> $LOG 2>&1 
  cp -f microlinux-wallpapers/* /usr/share/backgrounds/ >> $LOG 2>&1
  touch /usr/share/backgrounds/.microlinux >> $LOG 2>&1
  cd - >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

echo

exit 0
