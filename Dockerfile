FROM php:7.1-fpm

ENV DEBIAN_FRONTEND noninteractive
 
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \ 
    && apt-get update && apt-get install -y \
    cron \
    apt-utils \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libsqlite3-dev \
    libssl-dev \
    libcurl3-dev \
    libxml2-dev \
    libzzip-dev \
    libbz2-dev \
    locales \
    --reinstall procps \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install iconv json mcrypt mysqli pdo_mysql pdo_sqlite phar curl ftp hash session simplexml tokenizer xml xmlrpc zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install gettext \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install bcmath

RUN echo "deb http://httpredir.debian.org/debian/ jessie-backports main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    imagemagick ffmpeg libreoffice ghostscript \
    && pecl install imagick \
    && pecl install apcu \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable apcu
 
RUN echo nl_BE.UTF-8 UTF-8 > /etc/locale.gen && \
    echo de_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
    echo de_BE UTF-8 >> /etc/locale.gen && \
    echo fr_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
    echo fr_BE UTF-8 >> /etc/locale.gen && \
    echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen && \
    echo fr_FR UTF-8 >> /etc/locale.gen && \
    echo en_US.UTF-8 UTF-8  >> /etc/locale.gen && \
    echo en_US UTF-8  >> /etc/locale.gen && \
    locale-gen
     
RUN echo "apc.enabled=1" >  /usr/local/etc/php/conf.d/apcu.ini && \
    echo "apc.enable_cli=1" >>  /usr/local/etc/php/conf.d/apcu.ini && \
    echo "post_max_size=64M" >  /usr/local/etc/php/conf.d/upload.ini && \
    echo "upload_max_filesize=64M" >>  /usr/local/etc/php/conf.d/upload.ini
    
RUN chown -R www-data:www-data /var/www


WORKDIR /pipeline/source

