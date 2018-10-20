module "network-management" {
  source          = "../terraform/modules/openstack/networking/network"
  name            = "management"
  cidr            = "192.168.200.0/24"
  external-net-id = "f2dcc4ee-9ff4-443c-9bab-2a4b02200ea6"
  subnet-count    = 1
  dns-nameservers = ["10.26.205.34"]
}

module "network-inet" {
  source          = "../terraform/modules/openstack/networking/network"
  name            = "inet"
  cidr            = "192.168.100.0/24"
  external-net-id = "0c7e7930-740e-419c-8377-c65a22eb3c31"
  subnet-count    = 1
  dns-nameservers = ["10.26.205.34"]
}

module "network-corp" {
  source          = "../terraform/modules/openstack/networking/network"
  name            = "corp"
  cidr            = "192.168.101.0/24"
  external-net-id = "8c0879d9-8247-46e3-b985-45a5dff37116"
  subnet-count    = 1
  dns-nameservers = ["10.26.205.34"]
}

resource "openstack_compute_secgroup_v2" "management" {
  name        = "test"
  description = "Management network access rules"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_keypair_v2" "main" {
  name       = "sdops-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClk2d4WxqTh7/P6MkDF5Ytyqe4kpJ4BK44J64xI9hINVwE+Bb2Dujej5FSmtZHwYirNX4JxUoCkwIuTphpo6zeqzOxq/Wz6bXm6CCoZ2b+MUTDrsCeBg7vpCeLcCa4DvdTU6ejXr3eqfWCY8NSIOIOdNFL/vw3nbdSpM7hb0DYcihtI8BDY5FJAV2iBCV31Eiq5/gXGBI0pDzpSPqz3euau9eDtjBkZGwq4VXkWSsYFYkTZzu4/ejA+B4yZo459e7gFOKe4a2L1wJ23HDBceUH6Y3ieeFiF9VQ0u/egTCEYkmL8p//u2nuU3ifEcAL15P9BLlBmrZjg725TZlocH0v"
}

module "pool-instances" {
    source                  = "../terraform/modules/openstack/instance/3-networks"
    number                  = "${var.instance-count}"
    keypair-name            = "${openstack_compute_keypair_v2.main.name}"
    name                    = "test"
    image                   = "TID-RH75.20181001"
    flavor                  = "TID-02CPU-04GB-20GB"
    security-group-names    = ["${openstack_compute_secgroup_v2.management.name}"]
    network-names           = [
        "${module.network-management.network-name}",
        "${module.network-inet.network-name}",
        "${module.network-corp.network-name}"
    ]
}

module "swap-volumes" {
  source            = "../terraform/modules/openstack/storage/instance-blockstorage"
  number            = "${var.instance-count}"
  name              = "swap"
  device            = "/dev/vdb"
  size              = 5
  instance-names    = ["${module.pool-instances.instance-names}"]
  instance-ids      = ["${module.pool-instances.instance-ids}"]
}
module "data-volumes" {
  source            = "../terraform/modules/openstack/storage/instance-blockstorage"
  number            = "${var.instance-count}"
  name              = "data"
  device            = "/dev/vdc"
  size              = 10
  instance-names    = ["${module.pool-instances.instance-names}"]
  instance-ids      = ["${module.pool-instances.instance-ids}"]
  wait-volume-ids   = ["${module.swap-volumes.volume-ids}"]
}

module "ds-volumes" {
  source            = "../terraform/modules/openstack/storage/instance-blockstorage"
  number            = "${var.instance-count}"
  name              = "ds"
  device            = "/dev/vdd"
  size              = 20
  instance-names    = ["${module.pool-instances.instance-names}"]
  instance-ids      = ["${module.pool-instances.instance-ids}"]
  wait-volume-ids   = ["${module.data-volumes.volume-ids}"]
}

module "floating-ip-mgmt" {
  source        = "../terraform/modules/openstack/networking/floating-ip"
  number        = "${var.instance-count}"
  ip-pool       = "${lookup(var.ip-pools,"mgmt")}"
  instance-ids  = ["${module.pool-instances.instance-ids}"]
  instance-ips  = ["${module.pool-instances.network-1-ipv4}"]
}
