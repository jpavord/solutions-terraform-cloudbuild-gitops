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
  env = "dev"
}

provider "google" {
  project = "${var.project}"
}

module "vpc" {
  source  = "../../modules/vpc"
  project = "${var.project}"
  env     = "${local.env}"
}

module "http_server" {
  source  = "../../modules/http_server"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
}

module "mysql-db" {
  source               = "../../modules/mysql"
  name                 = "${module.mysql.db_name}"
  random_instance_name = false
  database_version     = "${module.mysql.database_version}"
  project_id           = "${module.mysql.project_id}"
  zone                 = "${module.mysql.zone}"
  region               = "${module.mysql.region}"
  tier                 = "${module.mysql.tier}"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = "${module.mysql.private_network}"
    require_ssl         = false
    authorized_networks = "${module.mysql.authorized_networks}"
  }
}
  
module "front_server" {
  source  = "../../modules/front_server"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
}

module "firewall" {
  source  = "../../modules/firewall"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
}
