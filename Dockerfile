FROM php:7.1-fpm

RUN apt-get update && apt-get install -y \
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
	libmagickwand-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install iconv json mcrypt mbstring mysqli pdo_mysql pdo_sqlite phar curl ftp hash session simplexml tokenizer xml xmlrpc zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install gettext \
    && docker-php-ext-install bz2

RUN     echo nl_BE.UTF-8 UTF-8 > /etc/locale.gen && \
        echo de_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo de_BE UTF-8 >> /etc/locale.gen && \
        echo fr_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo fr_BE UTF-8 >> /etc/locale.gen && \
        echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo fr_FR UTF-8 >> /etc/locale.gen && \
        echo en_US.UTF-8 UTF-8  >> /etc/locale.gen && \
        echo en_US UTF-8  >> /etc/locale.gen && \
        locale-gen

RUN sed -i '/session.*required.*pam_loginuid.so/s/session/#session/g' /etc/pam.d/cron

WORKDIR /pipeline/source


ADD ./entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]