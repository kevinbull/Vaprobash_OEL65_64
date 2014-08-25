echo "Installing Oracle"
sudo rpm -Uvh /vagrant/oracle/oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm
sudo rpm -Uvh /vagrant/oracle/oracle-instantclient12.1-devel-12.1.0.1.0-1.x86_64.rpm
sudo rpm -Uvh /vagrant/oracle/oracle-instantclient12.1-sqlplus-12.1.0.1.0-1.x86_64.rpm

echo "configuring oracle client"
sudo chown -R vagrant:vagrant /etc/ld.so.conf.d
sudo echo "/usr/lib/oracle/12.1/client64/lib" >> /etc/ld.so.conf.d/oracle.conf
sudo chown -R root:root /etc/ld.so.conf.d

sudo ldconfig

export PATH=$PATH:/usr/lib/oracle/12.1/client64/bin

echo "Installing Pecl OCI8"
echo "instantclient,/usr/lib/oracle/12.1/client64/lib" | sudo pecl install oci8

sudo chown vagrant:vagrant /etc/php.ini
sudo echo "extension=oci8.so" >> /etc/php.ini
