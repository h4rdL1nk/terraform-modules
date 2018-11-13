
variable "keypair-name" {}

variable "name" {}

variable "image" {}

variable "flavor" {}

variable "number" {}

variable "availability-zones" {
  type = "list"
}

variable "security-group-names" {
  type = "list"
}

variable "network-names" {
  type = "list"
}

variable "instance-metadata" {
  type = "map"

  default = {
    dummy = "empty"
  }
}
