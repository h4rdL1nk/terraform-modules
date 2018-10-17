resource "openstack_networking_router_v2" "routers" {
  name                = "router-${var.name}"
  admin_state_up      = "true"
  external_network_id = "${var.external-net-id}"
}

resource "openstack_networking_network_v2" "networks" {
  name           = "${var.name}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnets" {
  count           = "${var.subnet-count}"
  name            = "subnet-${openstack_networking_network_v2.networks.name}-${count.index + 1}"
  network_id      = "${openstack_networking_network_v2.networks.id}"
  cidr            = "${var.cidr}"
  dns_nameservers = ["${var.dns-nameservers}"]
  ip_version      = 4
}

resource "openstack_networking_router_interface_v2" "router-interfaces" {
  count     = "${var.subnet-count}"
  router_id = "${openstack_networking_router_v2.routers.id}"
  subnet_id = "${element(openstack_networking_subnet_v2.subnets.*.id,count.index)}"
}
