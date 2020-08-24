terraform {
  # Версия terraform
  required_version = "> 0.12.0"
}

provider "google" {
  version = "2.15.0"
  project = var.project
  region  = var.region
}


resource "google_container_cluster" "k8s" {
  name     = "k8s"
  location = var.location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "app-project"
  location   = var.location
  cluster    = google_container_cluster.k8s.name
  node_count = var.count_ins

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_size_gb = 20
    tags         = ["app"]


    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_firewall" "k8s-allow-external" {
  name    = "k8s-allow-external"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["app"]
  direction     = "INGRESS"
  priority      = "1000"
}
