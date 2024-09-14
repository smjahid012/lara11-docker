# Use the official PHP image with Apache as the base image
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Enable Apache mod_rewrite for URL rewriting
RUN a2enmod rewrite

# Update package lists and install necessary libraries and tools
RUN apt-get update -y && apt-get install -y \
    apt-utils \
    libicu-dev \
    libmariadb-dev \
    unzip \
    zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
#RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
#    && apt-get install -y nodejs \
#    && apt-get install -y npm

# Copy Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions
RUN docker-php-ext-install gettext intl pdo_mysql

# Configure and install the GD library with support for FreeType and JPEG
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Configure Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Start Apache in the foreground
CMD ["apache2-foreground"]

