FROM qoopido/base:1.0.3
MAINTAINER Dirk Lüth <info@qoopido.com>

# Initialize environment
	CMD ["/sbin/my_init"]
	ENV DEBIAN_FRONTEND noninteractive

# configure defaults
	COPY configure.sh /
	ADD config /config
	RUN chmod +x /configure.sh \
		&& chmod 755 /configure.sh
	RUN /configure.sh \
		&& chmod +x /etc/my_init.d/*.sh \
		&& chmod 755 /etc/my_init.d/*.sh \
		&& chmod +x /etc/service/php71/run \
		&& chmod 755 /etc/service/php71/run

# install language pack required to add PPA
	RUN apt-get update \
		&& apt-get install -qy language-pack-en-base \
		&& locale-gen en_US.UTF-8
	ENV LANG en_US.UTF-8
	ENV LC_ALL en_US.UTF-8

# add PPA for PHP 7
	RUN add-apt-repository ppa:ondrej/php

# install packages
	RUN apt-get update \
		&& apt-get install -qy \
			php7.1 \
			php7.1-fpm \
			php7.1-dev \
			php7.1-cli \
			php7.1-common \
			php7.1-intl \
			php7.1-bcmath \
			php7.1-mbstring \
			php7.1-soap \
			php7.1-xml \
			php7.1-zip \
			php7.1-apcu \
			php7.1-json \
			php7.1-gd \
			php7.1-curl \
			php7.1-mcrypt \
			php7.1-mysql \
			php7.1-sqlite \
			php-memcached
			
# generate locales
	RUN cp /usr/share/i18n/SUPPORTED /var/lib/locales/supported.d/local \
		&& locale-gen

# install composer
	RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
		&& php -r "copy('https://composer.github.io/installer.sig', 'composer-setup.hash');" \
		&& php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('composer-setup.hash'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
		&& php composer-setup.php \
		&& php -r "unlink('composer-setup.php');"
		
# enable extensions

# disable extensions

# add default /app directory
	ADD app /app
	RUN mkdir -p /app/htdocs \
    	&& mkdir -p /app/data/sessions \
    	&& mkdir -p /app/data/logs \
    	&& mkdir -p /app/config

# cleanup
	RUN apt-get -qy autoremove \
		&& deborphan | xargs apt-get -qy remove --purge \
		&& rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /usr/share/doc/* /usr/share/man/* /tmp/* /var/tmp/* /configure.sh \
		&& find /var/log -type f -name '*.gz' -exec rm {} + \
		&& find /var/log -type f -exec truncate -s 0 {} +

# finalize
	VOLUME ["/app/htdocs", "/app/data", "/app/config"]
	EXPOSE 9000
	EXPOSE 9001
