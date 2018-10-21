variable "flavor" {}

variable "number" {}

variable "security-group-names" {
  type = "list"
}

variable "networks" {
  type = "list"
}
/*Example value for 'networks' variable
    networks = [
      {name = "management"},
      {name = "inet"},
      {name = "corp"}
    ]
*/

variable "instance-metadata" {
  type = "map"

  default = {
    dummy = "empty"
  }
}
