FROM debian:buster


RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
	#install nginx
	nginx \
	wget \
	openssl \
	supervisor \
	#download src file
	&& wget https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb \
	&& wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	#install mysql
	&& echo 4 | apt-get install -y ./mysql-apt-config_0.8.16-1_all.deb \
	&& apt-get update \
	&& echo "mysql-server mysql-server/root_password password mysql" | debconf-set-selections \
	&& echo "mysql-server mysql-server/root_password_again password mysql" | debconf-set-selections \
	&& echo "mysql-server mysql-server/default-auth-override select Use Strong Password Encryption (RECOMMENDED)" | debconf-set-selections \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
	&& apt-get install -y \
	libmysqlclient-dev \
	php-mbstring \
	php-zip \
	wordpress \
	#install phpmyadmin
	&& tar -xf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /usr/share/phpmyadmin \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
