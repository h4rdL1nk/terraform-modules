variable "subnet-count" {}

variable "cidr" {}

variable "name" {}

variable "external-net-id" {}

variable "dns-nameservers" {
  type = "list"

  default = []
}

variable "host-routes" {
  type = "list"

  default = []
}
