#!/bin/bash

# Paramètres
history_file = "backup_history"
selection_file = "server_selection"
selection_number = $(head -c 1 "$selection_file")
if [ "$selection_number" -ne 0 ] && [ "$selection_number" -ne 1 ]; then
    echo "WARNING : Fichier $selection_file invalide. (Première fois ? Ignorez-moi!)"
	selection_number = "0"
fi


# Title + Logs
echo "   _____           _       _     _                _                ";
echo "  / ____|         (_)     | |   | |              | |               ";
echo " | (___   ___ _ __ _ _ __ | |_  | |__   __ _  ___| | ___   _ _ __  ";
echo "  \___ \ / __| '__| | '_ \| __| | '_ \ / _\` |/ __| |/ / | | | '_ \ ";
echo "  ____) | (__| |  | | |_) | |_  | |_) | (_| | (__|   <| |_| | |_) |";
echo " |_____/ \___|_|  |_| .__/ \__| |_.__/ \__,_|\___|_|\_\\__,_| .__/ ";
echo "                    | |                                     | |    ";
echo "                    |_|                                     |_|    ";
date_formatted=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$date_formatted] Démarrage d'une backup sur $next_server... \n" >> $history_file
echo "Note: La dernière backup effectuée avec succès a été faite sur $last_server"
echo "Démarrage de la backups sur $next_server dans 10 secondes..."

# Fermeture du proxy et des serveurs
echo "(1/2) Fermeture des services... "
sudo systemctl stop velocity
sudo systemctl stop mc-lobby
sudo systemctl stop mc-survie

# Dump de la base de donnée des permissions
sudo mariadb-dump minecraft > /opt/mc-server/backup_luckperms.sql

# Synchronisation
echo "(2/2) Synchronisation avec le serveur $server_name... "
rclone sync /opt/mc-server mega: --delete-excluded -v

# Note :
#   --delete-excluded permet de supprimer les fichiers qui ne sont plus présent à la source.
#   -v Ajoute du verbose sinon on ne voit rien.

date_formatted=$(date +"%Y-%m-%d %H:%M:%S")

if [ $? -eq "0" ]; then
	if [ $selection_number -eq 1 ]; then
    	echo "0" > selection_file
	else
		echo "1" > selection_file
	fi
    echo "[$date_formatted] Fin de la backup sur $next_server : Succès \n \n" >> $history_file
	echo "--> La sauvegarde s'est terminée avec succès, redémarrage complet dans 10s..."
	sleep 10
	sudo reboot
else
	echo "[$date_formatted] Fin de la backup sur $next_server : ECHEC !!! \n \n" >> $history_file
	echo "ERREUR: Impossible d'effectuer la sauvegarde correctement, relancement des services dans 10s... "
	sleep 10
	sudo systemctl start velocity
	sudo systemctl start mc-lobby
	sudo systemctl start mc-survie
fi
