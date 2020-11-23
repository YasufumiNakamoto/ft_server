FROM debian:buster

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
	nginx \
	curl \
	wget \
	systemd \

	#install mysql
	&& wget https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb \
	&& apt-get install -y ./mysql-apt-config_0.8.16-1_all.deb \
	#input 4?
	&& apt-get update \
	&& apt-get install -y \
	mysql-server \
	#input enter and 1?
	libmysqlclient-dev \
	wordpress \
	php-mbstring \
	php-zip \

	#install phpmyadmin
	&& wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /usr/share/phpmyadmin \




	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
