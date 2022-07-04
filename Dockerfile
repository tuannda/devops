FROM php:8.1-apache

ENV ACCEPT_EULA=Y

# Install prerequisites required for tools and extensions installed later on.
RUN apt-get update \
    && apt-get install -y bash gnupg libpng-dev libzip-dev unzip

# Microsoft SQL Server Prerequisites
RUN apt-get update \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list \
    > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
    locales \
    apt-transport-https \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    unixodbc-dev \
    msodbcsql18 \
    mssql-tools

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_mysql bcmath exif gd intl opcache pcntl zip ds redis xdebug swoole pdo_sqlsrv sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug redis gd

WORKDIR /var/www/html
