#!/bin/bash

# Ouverture du répertoire
cd /home/ubuntu/

# Fermeture du proxy et des serveurs
sudo systemctl stop velocity
sudo systemctl stop mc-lobby
sudo systemctl stop mc-survie

# Synchronisation
rclone sync /opt/mc-server mega: --delete-excluded -v

# Note :
#   --delete-excluded permet de supprimer les fichiers qui ne sont plus présent à la source.
#   -v Ajoute du verbose sinon on ne voit rien.

# Redémarrage complet du serveur pour faire la maintenance.
if [ $? -eq 0 ]; then
	echo "La sauvegarde s'est terminée avec succès, redémarrage complet dans 10s..."
	sleep 10
	sudo reboot
else
	echo "ERREUR: Impossible d'effectuer la sauvegarde correctement, relancement des services dans 10s... "
	sleep 10
	sudo systemctl stop velocity
	sudo systemctl start mc-lobby
	sudo systemctl start mc-survie
fi
