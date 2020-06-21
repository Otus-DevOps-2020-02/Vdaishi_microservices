resource "google_compute_instance" "docker" {
  count = var.count_ins
  name = "docker-host-${count.index}"
  machine_type = var.machine_type
  zone = var.zone
  tags = ["docker-host"]
  boot_disk {
    initialize_params {
       image = var.docker_disk_image
       size = "100"
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip[count.index].address
    }
  }
}
resource "google_compute_address" "app_ip" {
  count = var.count_ins
  name = "app-ip-${count.index}"
}
resource "google_compute_firewall" "firewall_http" {
  name = "puma-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["docker-host"]
}
resource "google_compute_firewall" "docker-machines" {
  name = "docker-machines"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["2376"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["docker-host"]
}
