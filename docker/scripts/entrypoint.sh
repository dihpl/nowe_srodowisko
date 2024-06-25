#!/bin/bash

# Copy example files if they don't exist
if [ ! -f /var/www/html/app/config/parameters.php ]; then
    cp /var/www/html/app/config/parameters_example.php /var/www/html/app/config/parameters.php
fi

if [ ! -f /var/www/html/.htaccess ]; then
    cp /var/www/html/.htaccess_example /var/www/html/.htaccess
fi

# Start Apache
apache2-foreground
