variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  default     = "europe-west4"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable zone {
  description = "Zone"
  default     = "europe-west4-a"
}
variable count_ins {
  description = "Count Instance"
  default     = 1
}
variable docker_disk_image {
  description = "Disk image for docker-base"
  default = "docker-base"
}
variable machine_type {
  description = "Docker host machine type"
  default = "n1-standard-1"
}
