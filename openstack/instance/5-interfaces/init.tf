resource "openstack_compute_instance_v2" "main" {
  count           = "${var.number}"
  name            = "${format("%s-%02d", var.name, count.index + 1)}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair-name}"
  security_groups = ["${var.security-group-names}"]

  lifecycle {
      ignore_changes = [ "availability_zone" ]
  }

  metadata = "${var.instance-metadata}"

  availability_zone = "${element(var.availability-zones,count.index)}"

  network { 
      name = "${element(var.network-names,0)}"
  }
  network {
      name = "${element(var.network-names,1)}" 
  }
  network {
      name = "${element(var.network-names,2)}" 
  }
  network { 
      name = "${element(var.network-names,3)}"
  }
  network {
      name = "${element(var.network-names,4)}" 
  }
}
