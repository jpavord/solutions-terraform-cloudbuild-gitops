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


resource "google_compute_instance_from_machine_image" "bs-api-server" {
  provider = google-beta
  name     = "instance-from-machine-image"
  zone     = "us-central1-a"

  source_machine_image = "projects/devops-iac-334823/global/machineImages/bigsmart-api"

  metadata_startup_script = <<-EOF
  sudo git clone git@github.com:jpavord/test-cloudbuil-download.git /
  EOF

  network_interface {
    subnetwork = "${var.subnet}"

    access_config {
      # Include this section to give the VM an external ip address
    }
  }

  # Apply the firewall rule to allow external IPs to access this instance
  tags = ["bs-api-server", "http-server", "https-server"]
}
