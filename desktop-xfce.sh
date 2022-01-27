#!/bin/bash

echo "Startind...HTTPS"

echo "woo" > /etc/hostname

echo "127.0.0.1 app.xx food.xx vue.xx woo.xx db.xx" >> /etc/hosts

echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
chattr +i /etc/resolv.conf

sudo apt install -y apt-transport-https

sudo sed -i 's/http\:/https\:/g' /etc/apt/sources.list

sudo apt update -y

# PHP
echo "Startind...PHP"
sudo apt install -y curl wget zip gnupg2 ca-certificates lsb-release software-properties-common

sudo curl https://packages.sury.org/php/apt.gpg | gpg --dearmor > /usr/share/keyrings/sury-php.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list

sudo apt update
sudo apt upgrade -y
sudo apt install -y php7.4-fpm
sudo apt install -y php8.0-fpm
sudo apt install -y php8.1-fpm
sudo apt install -y php7.4-{mysql,json,xml,curl,mbstring,opcache,gd,imagick,imap,bcmath,bz2,zip,intl,redis,memcache,memcached}
sudo apt install -y php8.0-{mysql,xml,curl,mbstring,opcache,gd,imagick,imap,bcmath,bz2,zip,intl,redis,memcache,memcached}
sudo apt install -y php8.1-{mysql,xml,curl,mbstring,opcache,gd,imagick,imap,bcmath,bz2,zip,intl,redis,memcache,memcached}

sudo update-alternatives --list php
sudo update-alternatives --set php /usr/bin/php8.0

# SERVER
echo "Startind...NGINX"
sudo apt install -y net-tools dnsutils mailutils git composer nginx

# Virtual hosts
sudo bash app-vhost.sh

# POSTFIX
echo "Startind...POSTFIX"
echo "postfix postfix/mailname string app.xx" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
sudo apt install -y postfix

echo "@app.xx max" > /etc/postfix/virtual
echo "@food.xx max" >> /etc/postfix/virtual
echo "@vue.xx max" >> /etc/postfix/virtual
echo "@localhost max" >> /etc/postfix/virtual
sudo postmap /etc/postfix/virtual

echo "" >> /etc/postfix/main.cf
echo "relayhost =" >> /etc/postfix/main.cf
echo "relay_domains =" >> /etc/postfix/main.cf
echo "mydestination = app.xx, food.xx, vue.xx, woo.localhost, localhost" >> /etc/postfix/main.cf
echo "virtual_alias_domains = app.xx food.xx vue.xx localhost" >> /etc/postfix/main.cf
echo "virtual_alias_maps = hash:/etc/postfix/virtual" >> /etc/postfix/main.cf

# FIREWALL
echo "Startind...FIREWALL"
sudo apt install -y ufw

sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw logging on
sudo ufw enable

# sudo ufw allow 22/tcp
# sudo ufw allow 25/tcp
# sudo ufw allow 80/tcp
# sudo ufw allow 443/tcp

# MYSQL
echo "Startind...MYSQL"
sudo apt remove -y --purge mariadb-server
sudo apt autoremove -y
sudo rm -rf /var/lib/mysql

sudo apt install -y mariadb-server

mysql -u root -e "
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
"

mysql -u root -e "
CREATE DATABASE app_xx CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE app_xx_testing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE food CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE food_testing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

GRANT ALL ON app_xx.* TO 'app_xx'@'localhost' IDENTIFIED BY 'toor' WITH GRANT OPTION;
GRANT ALL ON app_xx.* TO 'app_xx'@'127.0.0.1' IDENTIFIED BY 'toor' WITH GRANT OPTION;

GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY 'toor' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'toor' WITH GRANT OPTION;

FLUSH PRIVILEGES;
"

### db_root_password=toor
### mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('${db_root_password}') WHERE User='root';

mysql -u root -ptoor -e "SET GLOBAL FOREIGN_KEY_CHECKS=0;"
mysql -u root -ptoor < /home/max/www/food.xx/database/food-2021-10-18.sql
mysql -u root -ptoor -e "SET GLOBAL FOREIGN_KEY_CHECKS=1;"

# RESTART
echo "Startind...RESTART"

sudo chown -R www-data:www-data /etc/nginx/sites-enabled
sudo chmod -R 2775 /etc/nginx/sites-enabled

sudo service php7.4-fpm restart
sudo service php8.0-fpm restart
sudo service php8.1-fpm restart
sudo service nginx restart
sudo service mariadb restart
sudo service postfix restart

# PERMISSIONS
sudo mkdir -p /home/max/www
sudo chown -R max:www-data /home/max/www
sudo chmod -R 2775 /home/max/www
# Laravel app storage
sudo chown -R www-data:max /home/max/www/app.xx/storage/app
sudo chown -R www-data:max /home/max/www/app.xx/storage/logs
sudo chmod -R 2775 /home/max/www/app.xx/storage

# DESKTOP
echo "Startind...DESKTOP"
sudo apt install -y gthumb webp vlc lightdm-gtk-greeter-settings

# THUMBNAILS
rm -rf /home/max/.cache/thumbnails
echo "[Thumbnailer Entry]" > /usr/share/thumbnailers/webp.thumbnailer
echo "Exec=/usr/bin/dwebp %i -scale 100 75 -o %o" >> /usr/share/thumbnailers/webp.thumbnailer
echo "MimeType=image/x-webp;image/webp;" >> /usr/share/thumbnailers/webp.thumbnailer

# REMOVE
echo "Startind...REMOVE"
sudo apt remove --purge libreoffice* -y
sudo apt remove --purge avahi* -y
sudo apt autoremove -y

# MAIL
echo "Startind...MAIL"
echo "Test mail" | mail -s "Hello Maxiu" max@app.xx

# SCRIPTS Laravel
cd /home/max/www/app.xx && composer update && php artisan migrate:fresh --seed && php artisan storage:link
cd /home/max/www/food.xx && composer update && php artisan storage:link