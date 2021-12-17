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


output "network" {
  value = "${module.vpc.network}"
}

output "subnet" {
  value = "${module.vpc.subnet}"
}

output "firewall_rule" {
  value = "${module.firewall.firewall_rule}"
}

output "instance_name_api" {
  value = "${module.http_server.instance_name}"
}

output "external_ip" {
  value = "${module.http_server.external_ip}"
}

output "instance_name_front" {
  value = "${module.front_server.instance_name_front}"
}

output "external_ip_front" {
  value = "${module.front_server.external_ip_front}"
}

output "SQL-instance_name" {
  value       = "${module.mysql.instance_name}"
}

output "SQL-instance_ip_address" {
  value       = "${module.mysql.instance_ip_address}"
}

output "SQL-private_address" {
  value       = "${module.mysql.private_address}"
}

output "SQL-instance_first_ip_address" {
  value       = "${module.mysql.instance_first_ip_address}"
}
