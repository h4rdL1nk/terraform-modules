variable "number" {}
variable "name" {}
variable "instance_size" {}
variable "storage_os_disk_type" {}
variable "storage_extra_disks" {
  type = map
}
variable "tags" {
  type = map
}

variable "vm_image_reference" {
  type = map
}

variable "rg_location" {}
variable "rg_name" {}

variable "subnet_id" {}

variable "ssh_admin_user" {}
variable "ssh_public_key" {}