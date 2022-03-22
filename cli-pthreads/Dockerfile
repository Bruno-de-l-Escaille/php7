FROM php:7.2-zts-stretch

ENV DEBIAN_FRONTEND noninteractive

RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get update && apt-get install -y \
    cron \
    wget \
    unzip \
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
    && docker-php-ext-install mysqli pdo_mysql xmlrpc zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install gettext \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install bcmath \
    && wget https://codeload.github.com/krakjoe/pthreads/zip/master \
    && mv master master.zip && unzip master.zip \
    && cd  pthreads-master \
    && phpize && ./configure && make && make install \
    && pecl install apcu \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable apcu

#    echo "deb http://httpredir.debian.org/debian/ jessie-backports main" >> /etc/apt/sources.list && \
#    apt-get update && apt-get install -y \
#    libmagickwand-dev --no-install-recommends \
#    imagemagick ffmpeg libreoffice ghostscript \
#    && docker-php-ext-enable imagick \


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

RUN echo "apc.enabled=1" >  /usr/local/etc/php/conf.d/apcu.ini \
    && echo "apc.enable_cli=1" >>  /usr/local/etc/php/conf.d/apcu.ini \
    && echo "post_max_size=64M" >  /usr/local/etc/php/conf.d/upload.ini \
    && echo "upload_max_filesize=64M" >>  /usr/local/etc/php/conf.d/upload.ini \
    && echo "extension=mcrypt.so" >  /usr/local/etc/php/conf.d/mcrypt.ini \
    && echo "extension=pthreads.so" >  /usr/local/etc/php/conf.d/pthreads.ini

RUN sed -i '/session.*required.*pam_loginuid.so/s/session/#session/g' /etc/pam.d/cron

ADD entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]