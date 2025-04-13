FROM dunglas/frankenphp:1.5-php8.2.28-alpine

# Install dependencies using apk (Alpine's package manager)
RUN apk update && apk add --no-cache \
    php82 \
    php82-cli \
    php82-pdo \
    php82-pdo_pgsql \
    php82-mbstring \
    php82-openssl \
    php82-zip \
    php82-xml \
    php82-curl \
    php82-tokenizer \
    git \
    curl \
    zip \
    unzip \
    postgresql-dev \
    libzip-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Set Working Directory
WORKDIR /var/www/html

# Copy app code
COPY . .

# Set permission folder
RUN chown -R www-data:www-data /var/www/html

# Set permission public folder
RUN chmod -R 755 /var/www/html
RUN chmod -R 777 /var/www/html/storage

# Copy entrypoint
COPY deploy/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy Frankenphp configuration
COPY deploy/frankenphp.json /etc/frankenphp.json
RUN chmod +x /etc/frankenphp.json

# Set root access
USER root

# Change permission script once during the build process
RUN chmod +x install.sh


CMD ["/entrypoint.sh"]
