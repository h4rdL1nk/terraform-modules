variable "number" {}

variable "ip-pool" {}

variable "wait-assoc" {
  default = false
}

variable "instance-ids" {
  type = "list"
}

variable "instance-ips" {
  type = "list"
}
