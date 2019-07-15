variable "subnet-ids" {
  type = "list"

  default = []
}

variable "route-dest" {
  type = "string"
}

variable "route-gw" {
  type = "string"
}