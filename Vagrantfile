# -*- mode: ruby -*-
# vi: set ft=ruby :

# Config Github Settings
github_username = "kevinbull"
github_repo     = "Vaprobash_OEL65_64"
github_branch   = "master"
github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"

# Server Configuration

hostname        = "thelogue.dev"

# Set a local private network IP address.
# See http://en.wikipedia.org/wiki/Private_network for explanation
# You can use the following IP ranges:
#   10.0.0.1    - 10.255.255.254
#   172.16.0.1  - 172.31.255.254
#   192.168.0.1 - 192.168.255.254
server_ip             = "192.168.56.120"
server_memory         = "1024" # MB
server_swap           = "2048" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# Languages and Packages
php_timezone          = "America/Chicago"    # http://php.net/manual/en/timezones.php

# PHP Options
composer_packages     = [        # List any global Composer packages that you want to install
  #"phpunit/phpunit:4.0.*",
  #"codeception/codeception=*",
  #"phpspec/phpspec:2.0.*@dev",
  #"squizlabs/php_codesniffer:1.5.*",
]

# Default web server document root
# Symfony's public directory is assumed "web"
public_folder         = "/vagrant"

symfony_root_folder   = "/vagrant/symfony" # Where to install Symfony.

Vagrant.configure("2") do |config|

  # Set server to Ubuntu 14.04
  config.vm.box = "stoilis/oel65-64"

  # Create a hostname, don't forget to put it to the `hosts` file
  # This will point to the server's default virtual host
  # TO DO: Make this work with virtualhost along-side xip.io URL
  config.vm.hostname = hostname

  # Create a static IP
  config.vm.network :private_network, ip: server_ip
  #config.vm.network :public_network, ip: server_ip

  # Use NFS for the shared folder
  config.vm.synced_folder ".", "/vagrant"
  #config.vm.synced_folder ".", "/vagrant",
  #          id: "core",
  #          :nfs => true,
  #          :mount_options => ['nolock,vers=3,udp,noatime']

  # If using VirtualBox
  config.vm.provider :virtualbox do |vb|

    vb.name = "Logue_OL65"

    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

  end

  ####
  # Base Items
  ##########

  # Set the server timezone
  #config.vm.provision "shell",
  #  inline: "echo setting timezone to #{server_timezone}; ln -sf /usr/share/zoneinfo/#{server_timezone} /etc/localtime"

  # Provision Base Packages
  config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap]

  # Provision PHP
  config.vm.provision "shell", path: "#{github_url}/scripts/php.sh", args: [php_timezone]

  # Enable MSSQL for PHP
  # config.vm.provision "shell", path: "#{github_url}/scripts/mssql.sh"

  # Provision Vim
  # config.vm.provision "shell", path: "#{github_url}/scripts/vim.sh", args: github_url

  # We want to do this before nginx so that the restart of services will pick it up
  # Provision Oracle
  #config.vm.provision "shell", path: "#{github_url}/scripts/oracle.sh"

  ####
  # Web Servers
  ##########

  # Provision Apache Base
  # config.vm.provision "shell", path: "#{github_url}/scripts/apache.sh", args: [server_ip, public_folder, hostname, github_url]

  # Provision Nginx Base
  config.vm.provision "shell", path: "#{github_url}/scripts/nginx.sh", args: [server_ip, public_folder, hostname, github_url]


  ####
  # Databases
  ##########

  # Provision MySQL
  # config.vm.provision "shell", path: "#{github_url}/scripts/mysql.sh", args: [mysql_root_password, mysql_version, mysql_enable_remote]

  # Provision PostgreSQL
  # config.vm.provision "shell", path: "#{github_url}/scripts/pgsql.sh", args: pgsql_root_password

  # Provision SQLite
  # config.vm.provision "shell", path: "#{github_url}/scripts/sqlite.sh"

  # Provision RethinkDB
  # config.vm.provision "shell", path: "#{github_url}/scripts/rethinkdb.sh", args: pgsql_root_password

  # Provision Couchbase
  # config.vm.provision "shell", path: "#{github_url}/scripts/couchbase.sh"

  # Provision CouchDB
  # config.vm.provision "shell", path: "#{github_url}/scripts/couchdb.sh"

  # Provision MongoDB
  # config.vm.provision "shell", path: "#{github_url}/scripts/mongodb.sh"

  # Provision MariaDB
  # config.vm.provision "shell", path: "#{github_url}/scripts/mariadb.sh", args: [mysql_root_password, mysql_enable_remote]

  ####
  # Search Servers
  ##########

  # Install Elasticsearch
  # config.vm.provision "shell", path: "#{github_url}/scripts/elasticsearch.sh"

  # Install SphinxSearch
  # config.vm.provision "shell", path: "#{github_url}/scripts/sphinxsearch.sh"

  ####
  # Search Server Administration (web-based)
  ##########

  # Install ElasticHQ
  # Admin for: Elasticsearch
  # Works on: Apache2, Nginx
  # config.vm.provision "shell", path: "#{github_url}/scripts/elastichq.sh"


  ####
  # In-Memory Stores
  ##########

  # Install Memcached
  # config.vm.provision "shell", path: "#{github_url}/scripts/memcached.sh"

  # Provision Redis (without journaling and persistence)
  # config.vm.provision "shell", path: "#{github_url}/scripts/redis.sh"

  # Provision Redis (with journaling and persistence)
  # config.vm.provision "shell", path: "#{github_url}/scripts/redis.sh", args: "persistent"
  # NOTE: It is safe to run this to add persistence even if originally provisioned without persistence


  ####
  # Utility (queue)
  ##########

  # Install Beanstalkd
  # config.vm.provision "shell", path: "#{github_url}/scripts/beanstalkd.sh"

  # Install Heroku Toolbelt
  # config.vm.provision "shell", path: "https://toolbelt.heroku.com/install-ubuntu.sh"

  # Install Supervisord
  # config.vm.provision "shell", path: "#{github_url}/scripts/supervisord.sh"

  # Install ØMQ
  # config.vm.provision "shell", path: "#{github_url}/scripts/zeromq.sh"

  ####
  # Additional Languages
  ##########

  # Install Nodejs
  # config.vm.provision "shell", path: "#{github_url}/scripts/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)

  # Install Ruby Version Manager (RVM)
  # config.vm.provision "shell", path: "#{github_url}/scripts/rvm.sh", privileged: false, args: ruby_gems.unshift(ruby_version)

  ####
  # Frameworks and Tooling
  ##########

  # Provision Composer
  # config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", privileged: false, args: composer_packages.join(" ")

  # Provision Laravel
  # config.vm.provision "shell", path: "#{github_url}/scripts/laravel.sh", privileged: false, args: [server_ip, laravel_root_folder, public_folder, laravel_version]

  # Provision Symfony
  # config.vm.provision "shell", path: "#{github_url}/scripts/symfony.sh", privileged: false, args: [server_ip, symfony_root_folder, public_folder]

  # Install Screen
  # config.vm.provision "shell", path: "#{github_url}/scripts/screen.sh"

  # Install Mailcatcher
  # config.vm.provision "shell", path: "#{github_url}/scripts/mailcatcher.sh"

  # Install git-ftp
  # config.vm.provision "shell", path: "#{github_url}/scripts/git-ftp.sh", privileged: false

  ####
  # Local Scripts
  # Any local scripts you may want to run post-provisioning.
  # Add these to the same directory as the Vagrantfile.
  ##########
  # config.vm.provision "shell", path: "./local-script.sh"

end
