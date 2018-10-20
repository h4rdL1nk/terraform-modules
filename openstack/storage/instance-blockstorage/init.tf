resource "openstack_blockstorage_volume_v2" "volume" {
  count = "${var.number}"
  name  = "${element(var.instance-names,count.index)}-${var.name}"
  size  = "${var.size}"
}

resource "openstack_compute_volume_attach_v2" "attach" {
  count       = "${var.number}"
  instance_id = "${element(var.instance-ids,count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.volume.*.id,count.index)}"
  device      = "${var.device}"
}
