#!/bin/bash
#
# profil.sh
#
# Ce script installe le profil par défaut pour les utilisateurs du bureau KDE.
# 
# (c) Nicolas Kovacs, 2018

CWD=$(pwd)
CONFIGDIR="$CWD/config/kde"
LAYOUTDIR="/usr/share/kde4/apps"
CUSTOMDIR="/etc/skel/.kde/share"
MIMEDIR="/etc/skel/.local/share/applications"
WINFFDIR="/etc/skel/.winff"

echo

echo ":: Suppression du profil existant."
rm -rf $CUSTOMDIR $MIMEDIR

echo ":: Création de l'arborescence du nouveau profil."
mkdir -p $CUSTOMDIR/apps/konsole
mkdir -p $CUSTOMDIR/config
mkdir -p $MIMEDIR
mkdir -p $WINFFDIR

echo ":: Configuration du bureau par défaut."
cat $CONFIGDIR/00-defaultLayout.js > $LAYOUTDIR/plasma-desktop/init/00-defaultLayout.js
cat $CONFIGDIR/layout.js > $LAYOUTDIR/plasma/layout-templates/org.kde.plasma-desktop.defaultPanel/contents/layout.js

echo ":: Configuration du menu Démarrer."
cat $CONFIGDIR/kickoffrc > $CUSTOMDIR/config/kickoffrc

echo ":: Configuration des applications par défaut."
cat $CONFIGDIR/emaildefaults > $CUSTOMDIR/config/emaildefaults
cat $CONFIGDIR/kdeglobals > $CUSTOMDIR/config/kdeglobals

echo ":: Configuration du gestionnaire de fenêtres."
cat $CONFIGDIR/kwinrc > $CUSTOMDIR/config/kwinrc

echo ":: Configuration de la souris."
cat $CONFIGDIR/kcminputrc > $CUSTOMDIR/config/kcminputrc

echo ":: Configuration du gestionnaire de fichiers Dolphin."
cat $CONFIGDIR/dolphinrc > $CUSTOMDIR/config/dolphinrc

echo ":: Configuration du terminal Konsole."
#cat $CONFIGDIR/Shell.profile > $CUSTOMDIR/apps/konsole/Shell.profile
cat $CONFIGDIR/konsolerc > $CUSTOMDIR/config/konsolerc
cat $CONFIGDIR/MLED.profile > $CUSTOMDIR/apps/konsole/MLED.profile
cat $CONFIGDIR/Solarized.colorscheme > $CUSTOMDIR/apps/konsole/Solarized.colorscheme

echo ":: Association des types de fichiers aux applications."
cat $CONFIGDIR/mimeapps.list > $MIMEDIR/mimeapps.list

echo ":: Configuration de WinFF."
cat $CONFIGDIR/cfg.xml > $WINFFDIR/cfg.xml

echo ":: Configuration de Gtkcdlabel."
cat $CONFIGDIR/gtkcdlabelrc > /etc/skel/.gtkcdlabelrc

echo

exit 0

