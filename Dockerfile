FROM debian:buster

WORKDIR /tmp/

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
	curl openssl supervisor \
	nginx \
	mariadb-server \
	wordpress \
	php-mbstring php-zip php-fpm php-pear \
	#install phpmyadmin
	&& curl -O https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar -xf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /usr/share/phpmyadmin \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
