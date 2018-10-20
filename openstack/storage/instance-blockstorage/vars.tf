variable "number" {}

variable "name" {}

# Dummy variable just to wait for other module to finish 
variable "wait-volume-ids" {
  type = "list"

  default = [
    "000000",
    "111111"
  ]
}

variable "device" {}

variable "size" {}

variable "instance-names" {
  type = "list"
}

variable "instance-ids" {
  type = "list"
}
