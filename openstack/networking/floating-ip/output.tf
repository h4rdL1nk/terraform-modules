output "instance-ids" {
    value = ["${openstack_compute_floatingip_associate_v2.ips-assoc.*.instance_id}"]
}

output "instance-ips" {
    value = ["${openstack_compute_floatingip_associate_v2.ips-assoc.*.fixed_ip}"]
}

output "floating-ips" {
    value = ["${openstack_compute_floatingip_associate_v2.ips-assoc.*.floating_ip}"]
}

