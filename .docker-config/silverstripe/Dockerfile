FROM brettt89/silverstripe-web:8.0-apache

RUN apt-get update && apt-get install -y \
	libzip-dev zip unzip git nano mariadb-client rsync

# Install additional extensions
RUN install-php-extensions imagick xdebug

# Install additional extensions
RUN install-php-extensions imagick xdebug

RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install composer
RUN curl https://getcomposer.org/composer.phar --create-dirs -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer

RUN curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin
