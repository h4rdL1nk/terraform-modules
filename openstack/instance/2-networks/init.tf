resource "openstack_compute_instance_v2" "main" {
  count           = 1
  name            = "test"
  image_name      = "TID-RH75.20181001"
  flavor_name     = "TID-02CPU-04GB-20GB"
  key_pair        = "${var.keypair-name}"
  security_groups = ["${var.security-group-names}"]

  network { 
      name = "${element(var.network-names,0)}"
  }
  network {
      name = "${element(var.network-names,1)}" 
  }
  network {
      name = "${element(var.network-names,2)}" 
  }
}