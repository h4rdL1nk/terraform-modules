resource "openstack_networking_port_v2" "management" {
  count           = "${lookup(var.instance-count,"lb")}"
  name            = "${format("%s_%s-%s-%02d", "management", var.instance-datacenter-default, lookup(var.instance-name,"lb"), count.index + 1)}"
  network_id     = "${module.network-management.network-id}"
  security_group_ids = ["${openstack_compute_secgroup_v2.management.id}"]

  admin_state_up = "true"

  fixed_ip {
      subnet_id = "${element(module.network-management.subnet-ids,count.index)}"
  }
}

resource "openstack_networking_port_v2" "inet" {
  count           = "${lookup(var.instance-count,"lb")}"
  name            = "${format("%s_%s-%s-%02d", "inet", var.instance-datacenter-default, lookup(var.instance-name,"lb"), count.index + 1)}"
  network_id     = "${module.network-internet.network-id}"
  security_group_ids = ["${openstack_compute_secgroup_v2.internet.id}"]

  admin_state_up = "true"

  fixed_ip {
      subnet_id = "${element(module.network-internet.subnet-ids,count.index)}"
  }

  # Assign floating VRRP IP here
  #allowed_address_pairs {
  #    ip_address = "1.1.1.1"
  #}
}

resource "openstack_compute_instance_v2" "main" {
  count           = "${lookup(var.instance-count,"lb")}"
  name            = "${format("%s-%s,%02d", var.instance-datacenter-default, lookup(var.instance-name,"lb"), count.index + 1)}"
  image_name      = "${var.instance-image-default}"
  flavor_name     = "${lookup(var.instance-flavor,"lb")}"
  key_pair        = "${openstack_compute_keypair_v2.main.name}"
  
  lifecycle {
      ignore_changes = [ "availability_zone" ]
  }

  metadata = {
    environment     = "micro"
    component_name  = "lb"
    component_type  = "haproxy"
  }

  availability_zone = "${element(var.instance-availability-zones,count.index)}"

  network {
      port = "${element(openstack_networking_port_v2.management.*.id,count.index)}"
  }

  network {
      port = "${element(openstack_networking_port_v2.inet.*.id,count.index)}"
  }
}
