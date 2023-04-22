##### NETWORK #####

resource "yandex_vpc_network" "network" {
}

resource "yandex_vpc_subnet" "public" {
  count = length(var.public_cidrs)
  name = "public-${count.index + 1}"
  network_id = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = var.public_cidrs[count.index]
}

resource "yandex_vpc_subnet" "private" {
  count = length(var.private_cidrs)
  name = "private-${count.index + 1}"
  network_id = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = var.private_cidrs[count.index]
  route_table_id = yandex_vpc_route_table.private-route-table.id
}

resource "yandex_vpc_gateway" "nat-gateway" {
  description = "NAT gateway for private subnets"
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private-route-table" {
  name = "private-route-table"
  network_id = "${yandex_vpc_network.network.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.nat-gateway.id}"
  }
}


##### OUTPUTS #####

output "public_subnets" {
  value = {
    for sub in yandex_vpc_subnet.public:
    sub.id => sub.v4_cidr_blocks
  }
}

output "private_subnets" {
  value = {
    for sub in yandex_vpc_subnet.private:
    sub.id => sub.v4_cidr_blocks
  }
}

