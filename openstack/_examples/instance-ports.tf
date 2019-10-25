### VRRP setup

resource "openstack_networking_secgroup_rule_v2" "inet-vrrp-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "112"
  remote_ip_prefix  = "${lookup(var.network-cidrs,"inet")}"
  security_group_id = "${openstack_compute_secgroup_v2.internet.id}"
}

resource "openstack_networking_port_v2" "inet-vrrp-port" {
  name            = "inet-vrrp-port"
  network_id     = "${module.network-internet.network-id}"
  security_group_ids = ["${openstack_compute_secgroup_v2.internet.id}"]

  fixed_ip {
      subnet_id = "${element(module.network-internet.subnet-ids,0)}"
  }
}

resource "openstack_networking_floatingip_v2" "inet-vrrp-floating-ip" {
  pool  = "ext_inet"
}

resource "openstack_networking_floatingip_associate_v2" "inet-vrrp-floating-ip-assoc" {
  floating_ip = "${openstack_networking_floatingip_v2.inet-vrrp-floating-ip.address}"
  port_id     = "${openstack_networking_port_v2.inet-vrrp-port.id}"
}

output "inet-vrrp-ip-address" {
    value = "${openstack_networking_port_v2.inet-vrrp-port.all_fixed_ips}"
}

output "inet-vrrp-floating-ip-address" {
    value = "${openstack_networking_floatingip_v2.inet-vrrp-floating-ip.address}"
}

### END VRRP setup
