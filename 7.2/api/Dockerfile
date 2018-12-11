FROM tamtampro/php:7.2

RUN echo "deb http://httpredir.debian.org/debian/ jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends imagemagick ffmpeg libreoffice ghostscript \
    && pecl install imagick \
    && docker-php-ext-enable imagick
