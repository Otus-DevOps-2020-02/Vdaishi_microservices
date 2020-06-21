terraform {
  # Версия terraform
  required_version = " ~> 0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "2.15"

  # ID проекта
  project = var.project

  region = var.region
}
resource "google_compute_project_metadata" "appuser" {
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
module "docker" {
  source          = "../modules/docker"
  count_ins  = var.count_ins
  machine_type = var.machine_type
  public_key_path = var.public_key_path
  zone            = var.zone
  docker_disk_image  = var.docker_disk_image
  private_key_path = var.private_key_path
}
