#!/bin/bash
set -e

echo "=== Mise à jour du système ==="
sudo dnf update -y
sudo dnf clean all

echo "=== Installation de Docker ==="
sudo dnf install -y docker

echo "=== Démarrage et activation du service Docker ==="
# Beaucoup de services Linux (Docker, Nginx, MySQL…) fonctionnent en mode daemon,
# c’est-à-dire qu’ils tournent en arrière-plan comme un service.
sudo systemctl start docker
sudo systemctl enable docker

echo "=== Configuration du groupe Docker pour ec2-user ==="
# Docker fonctionne comme un daemon root (dockerd).
# Pour éviter de taper 'sudo docker ...' à chaque fois, on ajoute l'utilisateur au groupe Docker.
sudo groupadd -f docker      # -f pour ne pas échouer si le groupe existe déjà
sudo usermod -aG docker ec2-user
newgrp docker                # applique immédiatement le nouveau groupe à la session

echo "=== Installation de Docker Compose ==="
DOCKER_COMPOSE_VERSION="v2.21.0"   # remplacer par la dernière version si nécessaire
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== Vérification de l'installation ==="
docker --version
docker-compose version

echo "=== Installation terminée ==="

