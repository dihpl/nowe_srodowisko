FROM php:7.4-apache

# Install required packages
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    libxslt1-dev \
    libmcrypt-dev \
    sendmail \
    nano \
    iputils-ping \
    cron \
    vim \
    && docker-php-ext-install zip mysqli pdo pdo_mysql gd intl mbstring xml xsl \
    && docker-php-ext-enable opcache

# Install ioncube loader
RUN curl -L -o /tmp/ioncube_loaders.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar xfz /tmp/ioncube_loaders.tar.gz -C /tmp \
    && mv /tmp/ioncube/ioncube_loader_lin_7.4.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube_loader.so \
    && echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube_loader.so" > /usr/local/etc/php/conf.d/00-ioncube.ini

# Setup apache
RUN a2enmod rewrite

# Copy entrypoint script
COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /var/www/html

# Exclude files
COPY .dockerignore /var/www/html/.dockerignore

ENTRYPOINT ["/entrypoint.sh"
