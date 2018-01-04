Poste de travail CentOS 7 KDE
=============================

Voici le script de post-installation dont je me sers pour configurer "aux
petits oignons" un poste de travail basé sur CentOS 7 et l'environnement de
bureau KDE. 

Prérequis
---------

Le point de départ, c'est une installation par défaut de CentOS 7. Dans l'écran
de sélection des paquets, on optera pour le groupe de paquets *KDE Plasma
Workspaces*, mais sans cocher les options supplémentaires comme *Applications
KDE*, *Applications Internet*, etc.

Le réseau n'est pas activé par défaut, il faut donc songer à l'activer
explicitement.

Lors de la procédure d'installation, créer un utilisateur provisoire `install`.


Utilisation
-----------

Une fois qu'on a effectué le redémarrage initial, on peut se connecter en tant
qu'utilisateur `install` et lancer une session graphique KDE.

L'utilitaire `git` ne fait pas partie d'une installation par défaut, il va donc
falloir l'installer. 

<pre>
# <strong>yum install git</strong>
</pre>

Récupérer le contenu de ce dépôt.

<pre>
# <strong>git clone https://github.com/kikinovak/centos-7-desktop-kde</strong>
</pre>

Lancer le script de post-installation.

<pre>
# <strong>cd centos-7-desktop-kde</strong>
# <strong>./postinstall.sh</strong>
</pre>

L'affichage du script est assez laconique. Pour en savoir un peu plus sur le
détail et la progression des opérations, on peut ouvrir un deuxième terminal et
afficher le fichier journal "à chaud", comme ceci.

<pre>
# <strong>tail -f /tmp/postinstall.log</strong>
</pre>

Le script se charge automatiquement des opérations suivantes.

  * Effectuer la mise à jour initiale du système.

  * Basculer SELinux en mode permissif.

  * Désactiver l'IPv6.

  * Personnaliser le shell Bash pour `root` et les utilisateurs.

  * Personnaliser la configuration de Vim.

  * Configurer les dépôts de paquets officiels de manière prioritaire.

  * Configurer les dépôts de paquets tiers : EPEL, Nux, Adobe, etc.

  * Installer une panoplie d'outils en ligne de commande.

  * Supprimer les applications inutiles.

  * Supprimer les polices TrueType exotiques qui encombrent les menus.

  * Installer une panoplie cohérente d'applications supplémentaires

  * Personnaliser les entrées du menu KDE

  * Installer le profil par défaut des nouveaux utilisateurs.

  * Installer une panoplie de polices TrueType avec le rendu Infinality.

  * Installer une collection de fonds d'écran.

**Remarque importante** : SELinux est basculé en mode permissif de manière
temporaire afin de permettre aux admins de résoudre manuellement les blocages
avant de rebasculer en mode renforcé. 

Une fois que le script est arrivé à terme, on peut créer un nouvel utilisateur.

<pre>
# <strong>useradd -c "Nicolas Kovacs" kikinovak</strong>
# <strong>passwd kikinovak</strong>
# <strong>usermod -a -G wheel kikinovak</strong>
</pre>

Après un deuxième redémarrage, il ne reste plus qu'à supprimer l'utilisateur
`install` provisoire.

<pre>
# <strong>userdel -r install</strong>
</pre>

-- (c) Nicolas Kovacs, 2018

