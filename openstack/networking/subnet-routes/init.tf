resource "openstack_networking_subnet_route_v2" "routes" {
  count            = "${length(var.subnet-ids)}"
  subnet_id        = "${element(var.subnetn-ids,count.index)}"
  destination_cidr = "${var.route-dest}"
  next_hop         = "${var.route-gw}"
}