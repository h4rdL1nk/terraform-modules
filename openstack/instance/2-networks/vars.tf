
variable "keypair-name" {}

variable "name" {}

variable "image" {}

variable "flavor" {}

variable "number" {}

variable "security-group-names" {
  type = "list"
}

variable "network-names" {
  type = "list"
}