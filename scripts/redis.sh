#!/usr/bin/env bash

echo ">>> Installing Redis"

redis_version  = "2.8.13"
redis_port     = "6379"

cd /etc
sudo wget http://download.redis.io/releases/redis-$redis_version.tar.gz
sudo tar xzf redis-$redis_version.tar.gz
cd redis-$redis_version
sudo make

echo "configuring redis"
sudo mkdir /etc/redis
sudo mkdir -p /var/redis/$redis_port
sudo cp /etc/redis-$redis_version/utils/redis_init_script /etc/init.d/redis_$redis_port

# Need to insert the following lines beginning with line 2 into /etc/init.d/redis_6379 to make it work with chkconfig
# chkconfig:2345 95 20
# description: ClearC2 Redis server service
# This script starts and stops the redis server
# processname:redis_6379

sudo sed -i "2i\# chkconfig:2345 95 20\n# description: ClearC2 Redis server service\n# This script starts and stops the redis server\n# processname:redis_6379\n" /etc/init.d/redis_6379

sudo sed -i "s/daemonize .*/daemonize yes/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/pidfile .*/pidfile \/var\/run\/redis_6379.pid/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/logfile .*/logfile \/var\/log\/redis_6379.log/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/dbfilename .*/dbfilename redis_6379.rdb/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/dir .*/dir \/var\/redis/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/hash-max-ziplist-entries .*/hash-max-ziplist-entries 512/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/hash-max-ziplist-value .*/hash-max-ziplist-value 255/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/list-max-ziplist-entries .*/list-max-ziplist-entries 512/" /etc/redis-2.8.13/redis.conf
sudo sed -i "s/list-max-ziplist-value .*/list-max-ziplist-value 255/" /etc/redis-2.8.13/redis.conf
sudo cp /etc/redis-2.8.13/redis.conf /etc/redis/6379.conf

sudo sysctl vm.overcommit_memory=1

echo "making redis commands globally available"
sudo ln -s /etc/redis-2.8.13/src/redis-server /usr/local/bin/redis-server
sudo ln -s /etc/redis-2.8.13/src/redis-cli /usr/local/bin/redis-cli

sudo rm -f /etc/redis-2.8.13.tar.gz

echo "Adding Redis service"
sudo chkconfig --add redis_6379
sudo chkconfig --level 2345 redis_6379 on

echo "Starting Redis service"
sudo service redis_6379 start

echo "finished provisioning!!!"
