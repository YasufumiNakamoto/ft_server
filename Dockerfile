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
	&& cp -rf /usr/share/wordpress/* /var/www/html/ \
	#install phpmyadmin
	&& curl -O https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar -xf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/html/phpmyadmin \
	#install envsubst
	&& curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst \
	&& chmod +x envsubst \
	&& mv envsubst /usr/local/bin \
	#delete cache
	&& apt-get clean \
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
	-subj "/C=JP/ST=tokyo/L=tokyo/O=42tokyo/OU=IT Department/CN=ynakamot"
#copy setting files
COPY ./srcs/pma_config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/nginx.conf.tmpl /tmp/nginx.conf.tmpl
COPY ./srcs/wp-config-default.php /etc/wordpress/config-default.php
COPY ./srcs/supervisord.conf /etc/supervisord.conf

#setting mysql
RUN	service mysql start \
	&& echo "CREATE DATABASE wpdb;"| mysql -u root \
	&& echo "CREATE USER 'wordpress'@'localhost' identified by 'wordpress';"| mysql -u root \
	&& echo "GRANT ALL PRIVILEGES ON wpdb.* TO 'wordpress'@'localhost' WITH GRANT OPTION;"| mysql -u root \

#copy init shell script
COPY ./srcs/start.sh /tmp/start.sh

ENTRYPOINT [ "/bin/bash", "/tmp/start.sh" ]