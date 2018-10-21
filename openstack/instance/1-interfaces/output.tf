output "instance-names" {
    value = ["${openstack_compute_instance_v2.main.*.name}"]
}

output "instance-ids" {
    value = ["${openstack_compute_instance_v2.main.*.id}"]
}

output "network-1-ipv4"{
    value = ["${openstack_compute_instance_v2.main.*.network.0.fixed_ip_v4}"]
}
