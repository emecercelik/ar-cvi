#!/bin/sh

#
# Ramp Installation Script
#

IFS=$(printf '\n\t')

which docker
DOCKERVERSION="Docker version 20.10.6, build 370c289"

if [ $? -eq 0 ]
then
    RESULT=$(docker --version | grep "Docker version");

    if [ "$RESULT" = "$DOCKERVERSION" ];
    then
        INSTALLDOCKER=0;
    else
        INSTALLDOCKER=1;
    fi
else
   INSTALLDOCKER=1;
fi

# Docker
if [ $INSTALLDOCKER -eq 1 ];
then
   sudo apt remove --yes docker docker-engine docker.io containerd runc
   sudo apt update
   sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
   wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
   sudo apt update
   sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
   sudo usermod --append --groups docker "$USER"
   sudo systemctl enable docker
   printf '\nDocker installed successfully\n\n'

   printf 'Waiting for Docker to start...\n\n'
   sleep 5
fi

# Docker Compose
sudo wget --output-document=/usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/$(wget --quiet --output-document=- https://api.github.com/repos/docker/compose/releases/latest | grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')/run.sh"
sudo chmod +x /usr/local/bin/docker-compose
sudo wget --output-document=/etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose"
printf '\nDocker Compose installed successfully\n\n'

sleep 5
printf 'Launch RAMP IoT platform containers...\n\n'
export RAMP_PATH=$(pwd)

sudo sysctl -w vm.max_map_count=262144
sudo docker-compose up -d


