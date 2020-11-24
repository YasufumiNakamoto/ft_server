FROM debian:buster

WORKDIR /tmp/

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
	vim curl openssl supervisor \
	nginx \
	mariadb-server \
	wordpress \
	php-mbstring php-zip php-fpm php-pear \
	#install phpmyadmin
	&& curl -O https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar -xf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/html/phpmyadmin \
	&& apt-get clean \
	&& cp -r /usr/share/wordpress/* /var/www/html/ \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz

#make self-signed ssl
RUN openssl req -newkey rsa:4096 \
	-x509 \
	-sha256 \
	-days 3650 \
	-nodes \
	-out server.crt \
	-keyout server.key \
	-subj "/C=JP/ST=tokyo/L=tokyo/O=42tokyo/OU=IT Department/CN=www.example.com"
#copy setting files
COPY ./srcs/pma_config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/nginx.conf /etc/nginx/sites-available/default
COPY ./srcs/php.ini /etc/php/7.3/fpm/php.ini
COPY ./srcs/wp-config-default.php /etc/wordpress/config-localhost.php

#copy debug files
#COPY ./srcs/index.html /tmp/index.html
COPY ./srcs/phpinfo.php /tmp/index.php
COPY ./srcs/start.sh /tmp/start.sh

#CMD bash start.sh