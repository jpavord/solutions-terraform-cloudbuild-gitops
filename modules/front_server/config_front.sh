#!/usr/bin/env bash
sudo source ~/.bashrc
sudo nvm install v10.20.1
sudo mkdir /big-admin
echo "<Directory /big-admin>
        Options Indexes FollowSymLinks
        AllowOverride all
        Require all granted
        </Directory>" | sudo tee /etc/apache2/apache2.conf > /dev/null
echo "<VirtualHost *:80>    
        ServerAdmin webmaster@localhost
        DocumentRoot /big-admin
        Header set Access-Control-Allow-Origin "*"
       
        ErrorLog \$\{APACHE_LOG_DIR}/error.log
        CustomLog \$\{APACHE_LOG_DIR}/access.log combined
        </VirtualHost>" | sudo tee /etc/apache2/sites-available/000-default.conf > /dev/null
sudo a2enmod rewrite
sudo a2enmod headers
touch /big-admin/.htaccess
echo "<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews
    </IfModule>
    RewriteEngine On
    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond \%\{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)/$ /$1 [L,R=301]
    # Handle Front Controller...
    RewriteCond \%\{REQUEST_FILENAME} !-d
    RewriteCond \%\{REQUEST_FILENAME} !-f
    RewriteRule ^ index.html [L]
    # Handle Authorization Header
    RewriteCond \%\{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:\%\{HTTP:Authorization}]
    </IfModule>" | sudo tee /big-admin/.htaccess > /dev/null
sudo service apache2 restart
