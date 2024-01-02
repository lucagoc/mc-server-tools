#!/bin/bash

install_path="/opt/mc-server"
current_user=$USER

# Preconfig
echo "Démarrage de la configuration du serveur"
echo "Note: Cette opération peut prendre plusieurs dizaines de minutes !"
sleep 3

# Installation des dépendances
echo "(1/7) Installation des dépendances..."
sudo apt update
sudo apt upgrade
sudo apt install firewalld openjdk17-jre-headless git unzip wget bash-completion

# Ouverture des ports
echo "(2/7) Ouverture des ports..."

# Minecraft Java
sudo firewall-cmd --permanent --zone=public --add-port=44444/tcp
sudo firewall-cmd --permanent --zone=public --add-port=44444/udp

# Minecraft Bedrock
sudo firewall-cmd --permanent --zone=public --add-port=44443/tcp
sudo firewall-cmd --permanent --zone=public --add-port=44443/udp

# SquareMap survie
sudo firewall-cmd --permanent --zone=public --add-port=8100/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8100/udp

sudo firewall-cmd --reload

# Installation de RClone
echo "(3/7) Installation de Rclone..."
wget https://rclone.org/install.sh
sudo ./install.sh
rm install.sh

# Setup de la configuration Rclone, cette partie n'est pas automatisée.
echo "(4/7) Lancement de la configuration de Rclone... "
rclone config

# Restauration de la backup
echo "(5/7) Restauration de la backup depuis le serveur... "
sudo mkdir $install_path
sudo chown $current_user:$current_user $install_path
rclone copy mega: $install_path

# Attribution des autorisations d'execution sur les lanceurs
echo "(6/7) Attributions des autorisations d'exécutions sur les scripts de démarrage... "
sudo adduser --system --no-create-home --group velocity
sudo adduser --system --no-create-home --group mc-backup
sudo adduser --system --no-create-home --group mc-lobby
sudo adduser --system --no-create-home --group mc-survie
sudo groupadd mc-server
sudo usermod -a -G mc-server $current_user
# Note: Ne pas ajouter les autres utilisateurs dans le même groupe, cela compromet l'isolement.

# Applique la permission 760 à tous les dossiers, puis changer les owner + Ajout d'un groupe
chown -R velocity:mc-server  $install_path/velocity
chown -R mc-lobby:mc-server  $install_path/mc-lobby
chown -R mc-survie:mc-server $install_path/mc-survie
chmod -R 760 $install_path

# Copie et activation des services de lancement automatique
echo "(7/7) Création des services et activation... "

sudo cp ./services/* /etc/systemd/system/

sudo systemctl enable velocity.service
sudo systemctl enable mc-lobby.service
sudo systemctl enable mc-survie.service
sudo systemctl enable mc-backup.timer

# Fin
echo "--> Terminé ! Redémarrage du serveur dans 60s..."
sleep 60
sudo reboot
