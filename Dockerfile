FROM debian:buster

RUN set -x \
	&& apt update \
	&& apt install -y \
	#install nginx, wordpress
	nginx \
	wordpress \
	#install some command CHECK need curl or not
	curl \
	wget \
	systemd \
	#install mysql
	&& wget https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb \
	&& echo 4 | apt install -y ./mysql-apt-config_0.8.16-1_all.deb \
	&& echo "mysql-server mysql-server/root_password password mysql" | debconf-set-selections \
	&& echo "mysql-server mysql-server/root_password_again password mysql" | debconf-set-selections \
	&& echo "mysql-server mysql-server/default-auth-override select Use Strong Password Encryption (RECOMMENDED)" | debconf-set-selections \
	&& apt update \
	&& DEBIAN_FRONTEND=noninteractive apt install -y \
	mysql-server \
	libmysqlclient-dev \
	php-mbstring \
	php-zip \
	#install phpmyadmin
	&& wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /usr/share/phpmyadmin \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*
