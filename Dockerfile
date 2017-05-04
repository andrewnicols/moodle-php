FROM php:5.6-apache
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y \
    gettext \
    libcurl4-openssl-dev \
    libpq-dev \
    libmysqlclient-dev \
    libldap2-dev \
    libxslt-dev \
    libxml2-dev \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libmemcached-dev \
    zlib1g-dev \
    libpng12-dev \
    libaio1 \
    unzip \
    ghostscript \
    locales

RUN echo 'Generating locales..'
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN echo 'en_AU.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen

RUN echo "Installing php extensions"
RUN docker-php-ext-install -j$(nproc) \
    intl \
    mysqli \
    opcache \
    pgsql \
    soap \
    xsl \
    xmlrpc \
    zip

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install -j$(nproc) ldap

RUN pecl install solr memcache redis mongodb igbinary apcu-4.0.11 memcached-2.2.0
RUN docker-php-ext-enable solr memcache memcached redis mongodb apcu igbinary

RUN echo 'apc.enable_cli = On' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

RUN apt-get clean
