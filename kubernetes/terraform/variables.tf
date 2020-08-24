variable "project" {
  description = "Project ID"
}

variable "region" {
  description = "Region"

  # Значение по умолчанию
  default = "europe-west4"
}

variable "location" {
  description = "Loaction"
}

variable "machine_type" {
  description = "type of machine"
}
variable "count_ins" {
  description = "number nodes-machines"
}
