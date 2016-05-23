#!/bin/bash
USER=$1;
IP=$2;

#install gitlab
ssh -t $USER@$IP "
sudo docker run --detach \
    --hostname $IP \
    --publish 8080:80 \
    --name gitlab \
    --restart always \
    --volume /opt/gitlab/config:/etc/gitlab:Z \
    --volume /opt/gitlab/logs:/var/log/gitlab:Z \
    --volume /opt/gitlab/data:/var/opt/gitlab:Z \
    gitlab/gitlab-ce:latest;
		sleep 5;
		sudo docker exec -it gitlab gitlab-ctl reconfigure;
    "
#add nginx config for gitlab
