#!/bin/bash

# NGINX vhosts

# VHOST app.xx
echo -e '
server {
	listen 80;
	listen [::]:80;
	server_name app.xx;
	root /home/max/www/app.xx/public;
	index index.php index.html;

	disable_symlinks off;
	client_max_body_size 100M;

	access_log /var/log/nginx/app.xx.access.log;
	error_log /var/log/nginx/app.xx.error.log warn;

	location / {
		# try_files $uri $uri/ =404;
		try_files $uri $uri/ /index.php$is_args$args;
	}

	location ~ \.php$ {
		# fastcgi_pass 127.0.0.1:9000;
		fastcgi_pass unix:/run/php/php8.1-fpm.sock;
		include snippets/fastcgi-php.conf;
	}

	location ~* \.(jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp3|mp4|mov|ogg|ogv|webm|webp)$ {
		expires 1M;
		access_log off;
		add_header Cache-Control "public, no-transform";
	}

	location = /favicon.ico {
		rewrite . /favicon/favicon.ico;
	}
}' > /etc/nginx/sites-enabled/app.xx

# VHOST food.xx
echo -e '
server {
	listen 80;
	listen [::]:80;
	server_name food.xx;
	root /home/max/www/food.xx/public;
	index index.php index.html;

	disable_symlinks off;
	client_max_body_size 100M;

	access_log /var/log/nginx/food.xx.access.log;
	error_log /var/log/nginx/food.xx.error.log warn;

	location / {
		# try_files $uri $uri/ =404;
		try_files $uri $uri/ /index.php$is_args$args;
	}

	location ~ \.php$ {
		# fastcgi_pass 127.0.0.1:9000;
		fastcgi_pass unix:/run/php/php8.1-fpm.sock;
		include snippets/fastcgi-php.conf;
	}

	location ~* \.(jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp3|mp4|mov|ogg|ogv|webm|webp)$ {
		expires 1M;
		access_log off;
		add_header Cache-Control "public, no-transform";
	}

	location = /favicon.ico {
		rewrite . /favicon/favicon.ico;
	}
}' > /etc/nginx/sites-enabled/food.xx

# VHOST vue.xx
echo -e '
server {
	listen 80;
	listen [::]:80;
	server_name vue.xx;
	root /home/max/www/vue.xx;
	index index.php index.html;

	disable_symlinks off;
	client_max_body_size 100M;

	access_log /var/log/nginx/vue.xx.access.log;
	error_log /var/log/nginx/vue.xx.error.log warn;

	location / {
		# try_files $uri $uri/ =404;
		try_files $uri $uri/ /index.php$is_args$args;
	}

	location ~ \.php$ {
		# fastcgi_pass 127.0.0.1:9000;
		fastcgi_pass unix:/run/php/php8.1-fpm.sock;
		include snippets/fastcgi-php.conf;
	}

	location ~* \.(jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp3|mp4|mov|ogg|ogv|webm|webp)$ {
		expires 1M;
		access_log off;
		add_header Cache-Control "public, no-transform";
	}

	location = /favicon.ico {
		rewrite . /favicon/favicon.ico;
	}
}' > /etc/nginx/sites-enabled/vue.xx

# VHOST db.xx
echo -e '
server {
	listen 80;
	listen [::]:80;
	server_name db.xx;
	root /home/max/www/db.xx;
	index index.php index.html;

	disable_symlinks off;
	client_max_body_size 100M;

	access_log /var/log/nginx/db.xx.access.log;
	error_log /var/log/nginx/db.xx.error.log warn;

	location / {
		# try_files $uri $uri/ =404;
		try_files $uri $uri/ /index.php$is_args$args;
	}

	location ~ \.php$ {
		# fastcgi_pass 127.0.0.1:9000;
		fastcgi_pass unix:/run/php/php8.1-fpm.sock;
		include snippets/fastcgi-php.conf;
	}

	location ~* \.(jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp3|mp4|mov|ogg|ogv|webm|webp)$ {
		expires 1M;
		access_log off;
		add_header Cache-Control "public, no-transform";
	}

	location = /favicon.ico {
		rewrite . /favicon/favicon.ico;
	}
}' > /etc/nginx/sites-enabled/db.xx

# RESTART
sudo service php7.4-fpm restart
sudo service php8.0-fpm restart
sudo service php8.1-fpm restart
sudo service nginx restart

