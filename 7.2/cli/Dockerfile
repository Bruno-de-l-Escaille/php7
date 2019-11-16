FROM php:7.2-zts-stretch

ENV DEBIAN_FRONTEND noninteractive

RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get update && apt-get install -y \
    cron wget zip apt-utils procps \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libmcrypt-dev libsqlite3-dev libssl-dev libcurl3-dev \
    libxml2-dev libzip-dev libbz2-dev locales \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mysqli pdo_mysql bz2 zip bcmath gettext gd soap pcntl \
    && pecl install mcrypt-1.0.1 apcu redis \
    && docker-php-ext-enable apcu mcrypt redis \
    && echo nl_BE.UTF-8 UTF-8 > /etc/locale.gen \
    && echo de_BE.UTF-8 UTF-8 >> /etc/locale.gen \
    && echo de_BE UTF-8 >> /etc/locale.gen \
    && echo fr_BE.UTF-8 UTF-8 >> /etc/locale.gen \
    && echo fr_BE UTF-8 >> /etc/locale.gen \
    && echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen \
    && echo fr_FR UTF-8 >> /etc/locale.gen \
    && echo en_US.UTF-8 UTF-8  >> /etc/locale.gen \
    && echo en_US UTF-8  >> /etc/locale.gen \
    locale-gen

RUN echo "apc.enabled=1" >  /usr/local/etc/php/conf.d/apcu.ini \
    && echo "apc.enable_cli=1" >>  /usr/local/etc/php/conf.d/apcu.ini \
    && echo "post_max_size=64M" >  /usr/local/etc/php/conf.d/upload.ini \
    && echo "upload_max_filesize=64M" >>  /usr/local/etc/php/conf.d/upload.ini
RUN wget https://codeload.github.com/krakjoe/pthreads/zip/master \
    && mv master master.zip && unzip master.zip \
    && cd  pthreads-master \
    && phpize && ./configure && make && make install \
    && docker-php-ext-enable pthreads.so

WORKDIR /var/

ADD ./entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
