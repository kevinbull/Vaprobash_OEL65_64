#!/usr/bin/env bash

echo ">>> Installing Base Packages"

if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/kevinbull/Vaprobash_OEL65_64/master"
else
    github_url="$1"
fi

# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# US/Central for American Central
# US/Eastern for American Eastern
server_timezone  = "US/Central"

# Update
echo "Updating yum"
sudo yum update

echo "installing base packages"
sudo yum install -y unzip curl-devel expat-devel gettext-devel openssl-devel zlib-devel git-core

# Git Config and set Owner
curl --silent -L $github_url/helpers/gitconfig > /home/vagrant/.gitconfig
sudo chown vagrant:vagrant /home/vagrant/.gitconfig

# Common fixes for git
git config --global http.postBuffer 65536000

# Cache http credentials for one day while pull/push
git config --global credential.helper 'cache --timeout=86400'

echo "adding rpm repository"
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Set the server timezone
echo "setting timezone to #{server_timezone}; ln -sf /usr/share/zoneinfo/#{server_timezone} /etc/localtime"


echo ">>> Installing *.xip.io self-signed SSL"

SSL_DIR="/etc/ssl/thelogue.dev"
DOMAIN="*.thelogue.dev"
PASSPHRASE="logue"

SUBJ="
C=US
ST=Texas
O=ClearC2
localityName=Coppell
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

sudo mkdir -p "$SSL_DIR"

sudo openssl genrsa -out "$SSL_DIR/thelogue.dev.key" 1024
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/thelogue.dev.key" -out "$SSL_DIR/thelogue.dev.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "$SSL_DIR/xip.io.csr" -signkey "$SSL_DIR/thelogue.dev.key" -out "$SSL_DIR/thelogue.dev.crt"

# Setting up Swap

# Disable case sensitivity
shopt -s nocasematch

if [[ ! -z $2 && ! $2 =~ false && $2 =~ ^[0-9]*$ ]]; then

    echo ">>> Setting up Swap ($2 MB)"

    # Create the Swap file
    sudo fallocate -l $2M /swapfile

    # Set the correct Swap permissions
    sudo chmod 600 /swapfile

    # Setup Swap space
    sudo mkswap /swapfile

    # Enable Swap space
    sudo swapon /swapfile

    # Make the Swap file permanent
    echo "/swapfile   none    swap    sw    0   0" | sudo tee -a /etc/fstab

    # Add some swap settings:
    # vm.swappiness=10: Means that there wont be a Swap file until memory hits 90% useage
    # vm.vfs_cache_pressure=50: read http://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that
    #printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf && sysctl -p
    
    # For an explanation of swap files in Linux visit https://wiki.archlinux.org/index.php/swap
    sudo sysctl vm.swappiness=10
    sudo sysctl vm.vfs_cache_pressure=50
    sudo sysctl vm.overcommit_memory=1

fi

# Enable case sensitivity
shopt -u nocasematch
