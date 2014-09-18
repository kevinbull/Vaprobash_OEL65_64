#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

# If HHVM is installed, assume PHP is *not*
[[ $HHVM_IS_INSTALLED -eq 0 ]] && { PHP_IS_INSTALLED=-1; }

echo ">>> Installing Nginx"

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [[ -z $2 ]]; then
    public_folder="/vagrant"
else
    public_folder="$2"
fi

if [[ -z $3 ]]; then
    hostname=""
else
    # There is a space, because this will be suffixed
    hostname=" $3"
fi

if [[ -z $4 ]]; then
    github_url="https://raw.githubusercontent.com/kevinbull/Vaprobash_OEL65_64/master"
else
    github_url="$4"
fi

# Install Nginx
# -qq implies -y --force-yes
sudo yum install -y nginx

# Turn off sendfile to be more compatible with Windows, which can't use NFS
sudo sed -i 's/sendfile.*/sendfile off;/' /etc/nginx/nginx.conf

# Set the number of worker processes, typically this should be the number of CPU cores available
# cat /proc/cpuinfo| grep processor
sudo sed -i 's/worker_processes.*/worker_processes 1;/' /etc/nginx/nginx.conf

# Set run-as user for PHP5-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user.*nginx;/user vagrant;/" /etc/nginx/nginx.conf

# Set the virtual server name to something large enough - 64 should do it
sudo sed -i "s/http.*{/http {\n    server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sudo mkdir /etc/nginx/sites-enabled
sudo mkdir /etc/nginx/sites-available

# Set to look for confs in sites-enabled
sudo sed -i "s/include \/etc\/nginx\/conf.d\/.*;/include \/etc\/nginx\/sites-enabled\/\*.conf;/" /etc/nginx/nginx.conf

# Nginx enabling and disabling virtual hosts
# sudo curl --silent -L $github_url/helpers/ngxen.sh > ngxen
# sudo curl --silent -L $github_url/helpers/ngxdis.sh > ngxdis
# sudo curl --silent -L $github_url/helpers/ngxcb.sh > ngxcb
# sudo chmod +x ngxen ngxdis ngxcb
# sudo chown root:root ngxen ngxdis ngxcb
# # Move these files to a directory in the vagrant and root user PATH
# sudo mv ngxen ngxdis ngxcb /usr/bin

# # Create Nginx Server Block named $hostname and enable it
# sudo ngxcb -d $public_folder -n $hostname -s "$1.xip.io$hostname" -e

# Disable "default"
#sudo ngxdis default

if [[ $HHVM_IS_INSTALLED -ne 0 && $PHP_IS_INSTALLED -eq 0 ]]; then
    # PHP-FPM Config for Nginx
    sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini

    sudo service php-fpm restart
fi

sudo rm -rf /etc/nginx/conf.d/*

# create the web root for the logue
sudo mkdir -p /vagrant/thelogue
echo "<?php phpinfo();" > /vagrant/thelogue/app.php

# copy the thelogue conf file and activate it
sudo cp /vagrant/files/thelogue.dev.conf /etc/nginx/sites-available/thelogue.dev.conf
sudo ln -s /etc/nginx/sites-available/thelogue.dev.conf /etc/nginx/sites-enabled/thelogue.dev.conf


sudo service nginx restart
