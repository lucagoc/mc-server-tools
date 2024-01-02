#!/bin/bash

date_formatted=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$date_formatted] Démarrage d'une backup sur $a_server_name... " >> backup_history

echo "   _____           _       _     _                _                ";
echo "  / ____|         (_)     | |   | |              | |               ";
echo " | (___   ___ _ __ _ _ __ | |_  | |__   __ _  ___| | ___   _ _ __  ";
echo "  \___ \ / __| '__| | '_ \| __| | '_ \ / _\` |/ __| |/ / | | | '_ \ ";
echo "  ____) | (__| |  | | |_) | |_  | |_) | (_| | (__|   <| |_| | |_) |";
echo " |_____/ \___|_|  |_| .__/ \__| |_.__/ \__,_|\___|_|\_\\__,_| .__/ ";
echo "                    | |                                     | |    ";
echo "                    |_|                                     |_|    ";
echo "Note: La dernière backup effectuée avec succès a été faite sur $b_server_name à "
echo "Démarrage de la backups sur $a_server_name dans 10 secondes..."

# Fermeture du proxy et des serveurs

echo "(1/3) Fermeture des services... "
sudo systemctl stop velocity
sudo systemctl stop mc-lobby
sudo systemctl stop mc-survie

# Synchronisation
echo "(2/3) Synchronisation avec le serveur $server_name... "
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
	sudo systemctl start velocity
	sudo systemctl start mc-lobby
	sudo systemctl start mc-survie
fi
