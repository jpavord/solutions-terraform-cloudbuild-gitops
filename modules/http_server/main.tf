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
  touch known_hosts
  ssh-keyscan -t rsa github.com > known_hosts
  echo "server {
         listen 80 default_server;
         listen [::]:80 default_server;
         root /big_api;
         index index.html index.htm index.nginx-debian.html index.php;
         server_name _;
         location / { try_files \$uri \$uri/ /index.php?args; add_header 'Access-Control-Allow-Origin' '*'; }
         location ~ \.php$ { include snippets/fastcgi-php.conf; fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; }
}" | sudo tee /etc/nginx/sites-available/default > /dev/null
sudo mv /known_hosts ~/.ssh/
sudo touch /big_api/info.php
echo "<?php
phpinfo();
?>" | sudo tee /big_api/info.php > /dev/null
sudo touch /big_api/index.html
echo "<html><body><h1>Environment: ${local.network}</h1></body></html>" | sudo tee /big_api/index.html > /dev/null
sudo service nginx restart
touch ~/id_rsa
echo "test123123123123" | tee ~/id_rsa >/dev/null
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

  metadata = {
    id_rsa = "-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----"
known_hosts="github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
  }

  # Apply the firewall rule to allow external IPs to access this instance
  tags = ["bs-api-server", "http-server", "https-server"]
}
