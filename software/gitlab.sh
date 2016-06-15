#!/bin/bash
USER=$1;
IP=$2;
DOMAIN=$3;

#install gitlab
# ssh -t $USER@$IP "
# sudo docker run --detach \
#     --hostname $IP \
#     --publish 8080:80 --publish 4430:443 \
#     --name gitlab \
#     --restart always \
#     --volume /opt/gitlab/config:/etc/gitlab:Z \
#     --volume /opt/gitlab/logs:/var/log/gitlab:Z \
#     --volume /opt/gitlab/data:/var/opt/gitlab:Z \
#     gitlab/gitlab-ce:latest;
# 		sleep 5;
# 		sudo docker exec -it gitlab gitlab-ctl reconfigure;
#     "
# #add nginx config for gitlab

ssh -t $USER@$IP '
sudo apt-get install curl openssh-server ca-certificates postfix;
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash;
sudo apt-get install gitlab-ce;
sudo gitlab-ctl reconfigure;'; #hier koennten evtl probleme mit dem mailserver auftreten?

cp ../configs/gitlab-conf/gitlab.rb .;
sed -i.bak s/gitlab.site.de/$DOMAIN/g gitlab.rb;
rm *.bak;
scp gitlab.rb $USER@$IP:~/;
rm gitlab.rb;

ssh -t $USER@$IP '
sudo rm /etc/gitlab/gitlab.rb;
sudo mv gitlab.rb /etc/gitlab/;
#sudo ln -s /opt/gitlab/embedded/service/gitlab-rails/public /var/www/html/gitlab;
sudo gitlab-ctl reconfigure;';

../general-purpose/createNginxDomain.sh $USER $IP $DOMAIN gitlab;
