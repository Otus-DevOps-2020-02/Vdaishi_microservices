variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used in connections"
}
variable zone {
  description = "Zone"
  default     = "europe-west4-a"
}
variable docker_disk_image {
  description = "Disk image for reddit app"
  default = "ruby-app"
}
variable count_ins {
  description = "Count Instance"
  default     = 1
}
variable machine_type {
  description = "Docker host machine type"
  default = "n1-standard-1"
}
