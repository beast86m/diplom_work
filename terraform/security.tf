resource "yandex_vpc_security_group" "balancer-sg" {
  name        = "balancer-sg"
  description = "Разрешение на подключение к alb из сети Инертнет по HHTP (80)"
  network_id  = yandex_vpc_network.network-main.id
  
  egress {
    protocol       = "ANY"
    description    = "allow any outgoing connection"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "allow HTTP connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "TCP"
    description       = "Health checks"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "loadbalancer_healthchecks"
    port              = 30000
  }
  
}

resource "yandex_vpc_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Разрешение на подключение к ВМ bastion по SSH из сети Интернет"
  network_id  = yandex_vpc_network.network-main.id
  
  egress {
    protocol       = "ANY"
    description    = "allow any outgoing connection"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    description    = "allow SSH connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "allow ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "yandex_vpc_security_group" "kibana-sg" {
  name        = "kibana-sg"
  description = "Разрешение на подключение к kibana из сети Интернет"
  network_id  = yandex_vpc_network.network-main.id
  
    egress {
    protocol       = "ANY"
    description    = "allow any outgoing connection"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    description    = "allow kibana connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  ingress {
    protocol       = "TCP"
    description    = "allow ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "yandex_vpc_security_group" "zabbix-sg" {
  name        = "zabbix-sg"
  description = "Разрешение на подключение к zabbix из сети Интернет"
  network_id  = yandex_vpc_network.network-main.id
  
  egress {
    protocol       = "ANY"
    description    = "allow any outgoing connection"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    description    = "allow zabbix connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080
  }

  ingress {
    protocol       = "TCP"
    description    = "zabbix-agent"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 10050
  }
   ingress {
    protocol       = "TCP"
    description    = "zabbix-agent"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 10051
  }
}






resource "yandex_vpc_security_group" "inside" {
  name        = "inside"
  description = "Без ограничений внутри подсетей"
  network_id  = yandex_vpc_network.network-main.id
  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_alb_target_group" "target-group" {
  name = "target-group"

  target {
    subnet_id  = yandex_compute_instance.nginx1.network_interface.0.subnet_id
    ip_address = yandex_compute_instance.nginx1.network_interface.0.ip_address
  }
  target {
    subnet_id  = yandex_compute_instance.nginx2.network_interface.0.subnet_id
    ip_address = yandex_compute_instance.nginx2.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"
  http_backend {
    name             = "backend-group"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.target-group.id]
    
    load_balancing_config {
      panic_threshold = 9
    }
    
    healthcheck {
    #  healthcheck_port    = 80
      timeout             = "5s"
      interval            = "2s"
      healthy_threshold   = 2
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "http-router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "load-balancer" {
  name               = "load-balancer"
  network_id         = yandex_vpc_network.network-main.id
  security_group_ids = [yandex_vpc_security_group.inside.id, yandex_vpc_security_group.balancer-sg.id]
  
  allocation_policy {
    
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-nginx1.id
    }
    
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-nginx2.id
    }

  }
  
  
listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.address.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}
