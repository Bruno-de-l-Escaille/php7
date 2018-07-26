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
        git \
        wget \
    && docker-php-ext-install iconv json mcrypt mbstring mysqli pdo_mysql pdo_sqlite phar curl ftp hash session simplexml tokenizer xml xmlrpc zip bz2 \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install gettext \
    && pecl install apcu-5.1.4 && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

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

ADD ./install-composer.sh /bin/install-composer.sh 
RUN chmod +x /bin/install-composer.sh && \
    install-composer.sh && \
    mv composer.phar /usr/bin/composer

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]