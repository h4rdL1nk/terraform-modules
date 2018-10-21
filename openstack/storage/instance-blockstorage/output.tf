output "volume-ids" {
  value = ["${openstack_compute_volume_attach_v2.attach.*.volume_id}"]
}

output "volume-devs" {
  value = ["${openstack_compute_volume_attach_v2.attach.*.device}"]
}