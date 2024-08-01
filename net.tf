resource "yandex_vpc_network" "network-main" {
  name        = "network-main"
  description = "Общая сеть"
}


resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table" {
  name = "route-table"
  network_id = yandex_vpc_network.network-main.id
  
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id = yandex_vpc_gateway.nat_gateway.id
    
  }
}


resource "yandex_vpc_subnet" "subnet-nginx1" {
  name           = "subnet-nginx1"
  description    = "Подсеть ВМ1 nginx"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network-main.id
  route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_subnet" "subnet-nginx2" {
  name           = "subnet-nginx2"
  description    = "Подсеть ВМ1 nginx"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.20.0/24"]
  network_id     = yandex_vpc_network.network-main.id
  route_table_id = yandex_vpc_route_table.route_table.id
}
resource "yandex_vpc_subnet" "subnet-inside" {
  name           = "subnet-inside"
  description    = "Подсеть балансировщика"
  zone           = "ru-central1-d"
  v4_cidr_blocks = ["192.168.30.0/24"]
  network_id     = yandex_vpc_network.network-main.id
  route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_subnet" "subnet-bastion" {
  name           = "subnet-bastion"
  description    = "Подсеть ВМ bastion"
  zone           = "ru-central1-d"
  v4_cidr_blocks = ["192.168.40.0/24"]
  network_id     = yandex_vpc_network.network-main.id
  
}

resource "yandex_vpc_address" "address" {
  name = "vpc_address"

  external_ipv4_address {
    zone_id = "ru-central1-d"
  }
}
