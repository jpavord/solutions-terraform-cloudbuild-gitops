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

resource "google_compute_instance" "bs-api-server" {
  project      = "${var.project}"
  zone         = "us-central1-a"
  name         = "${local.network}-bigsmart-api"
  machine_type = "e2-micro"

  metadata_startup_script = <<-EOF
  sudo apt-get update -y
  sudo service apache2 stop
  sudo apt remove apache2 -y
  sudo apt-get install nginx -y
  sudo apt-get install php -y && apt install php7.4-gd php7.4-curl php7.4-fpm php7.4-json php7.4-mbstring php7.4-mysql php7.4-soap php7.4-xml php7.4-zip -y
  sudo apt-get install composer -y
  sudo mkdir /big_api
  touch ~/.ssh/id_rsa
  echo "-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----" | tee ~/.ssh/id_rsa > /dev/null
touch ~/.ssh/known_hosts
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrzPVMX1bnwX2Z/OCWY2uKjuIKdhQQObqSOYlo0W+3A8NDGDHVDjGNSEfIJArza76LV4U04R8KLFJ1K8VsAjr4mU0k5sXR63NxZwD4nv11qv/qFXHYLm2FWYgXW/Rou1+1QTohKGUJBii9h4FSYnFkpAT1yYu+I7hSt1Z+Q6iGXYAT5sBarENSc32jJtfS29gxRMrt8HNgnBxYxMgL9p3rwy+PE9d2Pl6z9OnyAIMeXl1uM0q8Qdn/5fwN5+OBiwyGMfVKER0evItnp2iHDJoSSI9oaz60AhkxYr3bvXMFIiiT6Alac/IUijMAMcDelmzNKgn5mQSSNA+aMYLBQD+MpcIYAHKEQ93x9LiYqKGVceB5VgBNHGOao4GKHxME5UXUh3iF0yrOc5idLYlYm3G29036qQRyycOIzaEXOUXccVXxYnOZ1DniiBjcTXwf/i2pGvGsgXD/W5sE+9bXhZ2rmef8I6RVPEBcgWn9Jk+CiGkqAGNzXkFNE9Dh6GcjUdTqtrGs/VgfuLTjM5MgzhPMXtVaRDZB7d/Aki/BhSYe68ADU/TN5iCjBN0sObDMgsSlNNEUYy0+s+RD3ErzkwyOX1tm1xuEcGHHNgGPhXKtT94j7Os7MVduxliq4ZYUb6DJdRiEQIQ8x5RHrX4oTkc70t95M4Yid82teLtazOrgkw== vargasordazjosepablo@gmail.com" | tee ~/.ssh/known_hosts > /dev/null
git clone git@github.com:jpavord/test-cloudbuil-download.git
echo "server {
         listen 80 default_server;
         listen [::]:80 default_server;
         root /big_api;
         index index.html index.htm index.nginx-debian.html index.php;
         server_name _;
         location / { try_files \$uri \$uri/ /index.php?args; add_header 'Access-Control-Allow-Origin' '*'; }
         location ~ \.php$ { include snippets/fastcgi-php.conf; fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; }
}" | sudo tee /etc/nginx/sites-available/default > /dev/null
sudo touch /big_api/info.php
echo "<?php
phpinfo();
?>" | sudo tee /big_api/info.php > /dev/null
sudo touch /big_api/index.html
echo "<html><body><h1>Environment: ${local.network}</h1></body></html>" | sudo tee /big_api/index.html > /dev/null
sudo service nginx restart
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
  tags = ["bs-api-server", "http-server", "https-server"]
}
