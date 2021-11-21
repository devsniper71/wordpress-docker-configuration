FROM php:8.0-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libgmp-dev \
    locales \
    zip \
    unzip \
    vim \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
# Start
RUN apt update
RUN apt upgrade -y

RUN apt install -y apt-utils
RUN apt install -y libmcrypt-dev
RUN apt install -y libicu-dev

RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) gd    
   
RUN apt install -y libxml2-dev 
RUN apt install -y libldb-dev
RUN apt install -y libldap2-dev 
RUN apt install -y libxml2-dev
RUN apt install -y libssl-dev
RUN apt install -y libxslt-dev
RUN apt install -y libpq-dev
RUN apt install -y postgresql-client
RUN apt install -y libsqlite3-dev
RUN apt install -y libsqlite3-0
RUN apt install -y libc-client-dev
RUN apt install -y libkrb5-dev
RUN apt install -y curl
RUN apt install -y libcurl3-dev
RUN apt install -y firebird-dev

RUN apt-get install -y libpspell-dev
RUN apt-get install -y aspell-en
RUN apt-get install -y aspell-de  

RUN apt install -y libtidy-dev
RUN apt install -y libsnmp-dev
RUN apt install -y librecode0
RUN apt install -y librecode-dev

RUN docker-php-ext-install opcache

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-install soap
RUN docker-php-ext-install ftp
RUN docker-php-ext-install xsl
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dba
RUN docker-php-ext-install dom
RUN docker-php-ext-install zip
RUN docker-php-ext-install session
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pdo
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_mysql 
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install gd
RUN docker-php-ext-install curl
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install gettext
RUN docker-php-ext-install iconv
RUN docker-php-ext-install pdo_firebird
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install phar
RUN docker-php-ext-install posix
RUN docker-php-ext-install pspell
RUN docker-php-ext-install shmop
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install snmp
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install tidy
RUN docker-php-ext-install xml
RUN docker-php-ext-install xmlwriter             
# End

# Install NodeJS & NPM
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
apt-get install -y nodejs

# Install imagick
# Version is not officially released https://pecl.php.net/get/imagick but following works for PHP 8
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    docker-php-ext-install imagick;

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
