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

resource "google_compute_instance" "http_server" {
  project      = "${var.project}"
  zone         = "us-central1-a"
  name         = "${local.network}-apache2-instance"
  machine_type = "e2-micro"

  metadata_startup_script = <<-EOF
  echo "zxc" | sudo -S apt-get update
  sudo service apache2 stop
  sudo systemctl disable apache2
  sudo apt-get install nginx -y
  sudo service nginx start 
  sudo apt install php -y
  sudo apt install php7.4-gd php7.4-curl php7.4-fpm php7.4-json php7.4-mbstring php7.4-mysql php7.4-soap php7.4-xml php7.4-zip -y
  sudo apt install composer -y
  sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/bkp_default_bkp
  echo "zxc" | sudo -S mkdir /big_api
  echo "server {
         listen 80 default_server;
         listen [::]:80 default_server;
         root /big_api;
         index index.html index.htm index.nginx-debian.html index.php;
         server_name _;
         location / { try_files $uri $uri/ /index.php?args; add_header 'Access-Control-Allow-Origin' '*'; }
         location ~ \.php$ { include snippets/fastcgi-php.conf; fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; }
}" | sudo tee /etc/nginx/sites-available/default > /dev/null
echo "zxc" | sudo -S touch /big_api/info.php
echo "<?php
phpinfo();
?>" | sudo tee /big_api/info.php > /dev/null
sudo touch /big_api/index.html
echo "<html><body><h1>Environment: ${local.network}</h1></body></html>" | sudo tee /big_api/index.html > /dev/null
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
  tags = ["http-server"]
}
