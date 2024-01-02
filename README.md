# Outils d'administration bash pour les serveurs Minecraft

## Description
Ce répertoire contient une liste d'outil afin de rapidement réinstaller un serveur Minecraft à plusieurs instances depuis une sauvegarde existante pour gagner du temps.
Je fais ça pour apprendre, je ne suis en aucun responsable d'une perte de donnée / faille de sécurité (sauf sur mon propre serveur).

## Installation du serveur
Copiez le répertoire et exécuter server-installation.sh

## Sauvegarde du serveur
Par défaut un service est actif pour faire une sauvegarde tous les matins à 2h (et reboot le serveur au passage).
Cependant une sauvegarde peut être forcée avec le script do-server-backup.sh

## FAQ
### Quel service de sauvegarde utiliser ?
Personnellement j'utilise MEGA qui propose gratuitement 20GB de stockage et la configuration rclone est très facile.

### J'ai trouvé un problème / une amélioration dans un script, comment contribuer ?
Tu peux ouvrir une pull request ou ouvrir une issue pour que m'expliquer en détail. (Merci beaucoup pour ton intêret !)
