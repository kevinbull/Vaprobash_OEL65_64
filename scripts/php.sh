#!/usr/bin/env bash

PHP_TIMEZONE=$1

echo ">>> Installing PHP"

# Install PHP
#sudo yum install -y php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp php5-mcrypt php5-xdebug php5-memcached php5-imagick php5-intl

sudo yum -y --enablerepo=remi,remi-php55 install php-devel php php-cli php-fpm php-bcmath php-curl php-gd php-gmp php-mcrypt php-igbinary-devel php-igbinary php-imap php-ldap php-imagick php-intl php-odbc php-openssl php-pspell php-pdo php-xdebug php-xhprof php-zip
# Need to figure out how to add php-pdo_oci which also loads php-oci8 as a dependency

# Set PHP FPM to listen on TCP instead of Socket
sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php-fpm.d/www.conf

# Set PHP FPM allowed clients IP address
sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php-fpm.d/www.conf

# Set run-as user for PHP5-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user = apache/user = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/group = apache/group = vagrant/" /etc/php-fpm.d/www.conf

sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php-fpm.d/www.conf


# xdebug Config
cat > $(find /etc/php.d -name xdebug.ini) << EOF
zend_extension=xdebug.so

xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9001
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1

; var_dump display
xdebug.var_display_max_depth = 5
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 1024
EOF

# PHP Error Reporting Config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php.ini

# PHP Date Timezone
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php.ini
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php.ini

# PHP Turn off the X-Powered-By Header that broadcasts the PHP version
sudo sed -i "s/expose_php =.*/expose_php = Off/" /etc/php.ini

# Install phpredis from GitHub
sudo mkdir -p /usr/src/phpredis
sudo git clone https://github.com/nicolasff/phpredis.git /usr/src/phpredis
cd /usr/src/phpredis
sudo phpize
sudo ./configure --enable-redis-igbinary
sudo make
sudo make install

# make session directory writable by vagrant
sudo chown vagrant:vagrant /var/lib/php/session

# get the mbstring extension
sudo yum --enablerepo=remi,remi-php55 install -y php-mbstring

# Start/Restart the frm service
sudo service php-fpm restart
