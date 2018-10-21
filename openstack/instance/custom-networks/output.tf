output "instance-names" {
    value = ["${openstack_compute_instance_v2.main.*.name}"]
}

output "instance-ids" {
    value = ["${openstack_compute_instance_v2.main.*.id}"]
}

output "networks"{
    value = ["${openstack_compute_instance_v2.main.*.network}"]
}

output "networks-ipv4"{
    value = ["${openstack_compute_instance_v2.main.*.network.*.fixed_ip_v4}"]
}
