#!/usr/bin/env bash

root_dir="/vagrant/thelogue";

# remove the root directory
sudo rm -rf $root_dir

# clone the repo
git clone git@github.com:ClearC2/TheLogue_dev.git $root_dir

# make cache, logs, and console accessible
sudo chmod -R 775 $root_dir/app/cache
sudo chmod -R 775 $root_dir/app/logs
sudo chmod -R 775 $root_dir/app/console

# install composer dependencies
cd $root_dir
composer install

# create non-shared cache/log dir
sudo mkdir -p /dev/shm/thelogue
sudo chown vagrant:vagrant /dev/shm/thelogue