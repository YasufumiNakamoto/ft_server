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
	&& rm -rf /var/lib/apt/lists/* \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz

COPY ./srcs/pma_config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/nginx.conf /etc/nginx/sites-available/default
