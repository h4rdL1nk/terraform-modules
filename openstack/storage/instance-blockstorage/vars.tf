variable "number" {}

variable "name" {}

# Dummy variable just to wait for other module to finish 
variable "wait" {
  type = "list"
}

variable "sleep" {
  default = 0
}

variable "device" {}

variable "size" {}

variable "instance-names" {
  type = "list"
}

variable "instance-ids" {
  type = "list"
}
