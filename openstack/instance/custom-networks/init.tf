resource "openstack_compute_instance_v2" "main" {
  count           = "${var.number}"
  name            = "${format("%s-%02d", var.name, count.index + 1)}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair-name}"
  security_groups = ["${var.security-group-names}"]

  metadata = "${var.instance-metadata}"

  availability_zone = "${element(var.availability-zones,count.index)}"

  network = ["${var.networks}"]
}
