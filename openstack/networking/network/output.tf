output "network-name" {
  value = "${openstack_networking_network_v2.networks.name}"
}

output "network-id" {
  value = "${openstack_networking_network_v2.networks.id}"
}

output "subnet-ids" {
  value = "${openstack_networking_subnet_v2.subnets.*.id}"
}
