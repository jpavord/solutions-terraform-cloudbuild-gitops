# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  network = "${element(split("-", var.subnet), 0)}"
}

resource "google_compute_instance" "bs-front-server" {
  project      = "${var.project}"
  zone         = "us-central1-a"
  name         = "${local.network}-bigsmart-front"
  machine_type = "e2-micro"

  metadata_startup_script = <<-EOF
  sudo apt-get update -y
  sudo apt-get install apache2 -y
  sudo  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
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
   sudo find /big-admin -type f -exec chmod 644 {} +
   sudo find /big-admin -type d -exec chmod 755 {} +
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
    touch /big-admin/index.html
    echo '<html><body><h1>Environment: ${local.network}</h1></body></html>' | sudo tee /big-admin/index.html
    touch /big-admin/info.php
    echo "<?php
    phpinfo();
    ?>" | sudo tee /big-admin/info.php
    sudo service apache2 restart
  EOF

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20211202"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    access_config {
      # Include this section to give the VM an external ip address
    }
  }

  # Apply the firewall rule to allow external IPs to access this instance
  tags = ["bs-front-server", "http-server", "https-server"]
}
