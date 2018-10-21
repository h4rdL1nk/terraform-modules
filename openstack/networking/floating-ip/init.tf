resource "openstack_networking_floatingip_v2" "ips" {
  count = "${var.number}"
  pool  = "${var.ip-pool}"
}

resource "openstack_compute_floatingip_associate_v2" "ips-assoc" {
  count       = "${var.number}"
  floating_ip = "${element(openstack_networking_floatingip_v2.ips.*.address,count.index)}"
  instance_id = "${element(var.instance-ids,count.index)}"
  fixed_ip    = "${element(var.instance-ips,count.index)}"
  wait_until_associated = "${var.wait-assoc}"
}
