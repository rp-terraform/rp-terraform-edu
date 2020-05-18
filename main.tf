provider "google" {
  credentials = file("./terraform-test-277002-e707c367d803.json")
  project = "terraform-test-277002" 
  region = "us-central-1"
  zone = "us-central-1c"
}
 
resource "google_compute_instance" "vm_instance" {
  name = "terraform-instance"
  machine_type = "f1-micro"
 
 
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
   }
}
 
network_interface {
  network = google_compute_network.vpc_network.self_link
  access_config {
  }
}
}
 
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
  auto_create_subnets = "true"
}

resource "google_compute_firewall" "allow-inbound" {
  name = "allow-inbound"
  network = "${google_compute_network.untrust.self_link}"

  allow {
  protocol = "tcp"
  ports = ["80","8000","8080","22"] 
  }
  
  source_ranges = ["112.220.232.86/32"]
}

resource "google_compute_firewall" "allow-outbound" {
  name = "allow-outbound"
  network = "${google_compute_network.untrust.self_link}"

  allow {
  protocol = "all"
  }
  
  source_ranges = ["112.220.232.86/32"]
}

