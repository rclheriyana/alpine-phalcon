FROM php:7.0-fpm-alpine
ENV TIMEZONE=Asia/Jakarta
# phalcon version
ENV PHALCON_VERSION=3.4.2
# iconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    # compiler & tools
    make \
    g++ \
    autoconf \
    file \
    libtool \
    libpng \
    libpng-dev \
    re2c \
    pcre-dev \
    gnu-libiconv \
    # iconv & gd
    php7-iconv \
    php7-gd \
    php7-intl \
    php7-xsl \
    php7-redis \
    php7-dev \
    php7-pear \
    php7-mysqli \
    php7-pdo \
    php7-pdo_mysql \
    php7-curl \
    && \
    # docker ext
    docker-php-ext-install curl && \
    docker-php-ext-install gd && \
    docker-php-ext-install pdo_mysql && \
    # phalcon php
    set -xe && \
    curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf v${PHALCON_VERSION}.tar.gz && \
    # compile
    cd cphalcon-${PHALCON_VERSION}/build && ./install && \
    echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
    cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} \
    && \
    # clean dev libs
    apk del \
    make \
    g++ \
    autoconf \
    file \
    libtool \
    re2c \
    libpng \
    libpng-dev \
    gnu-libiconv \
    pcre-dev \
    php7-dev \
    php7-pear \
    && rm -rf /var/cache/apk/*
