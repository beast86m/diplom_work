resource "yandex_compute_instance" "nginx1" {
  name                      = "nginx1"
  hostname                  = "nginx1"
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true
  
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-nginx1.id
    security_group_ids = [yandex_vpc_security_group.inside.id]
    ip_address         = "192.168.10.100"
  }
  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

resource "yandex_compute_instance" "nginx2" {
  name                      = "nginx2"
  hostname                  = "nginx2"
  zone                      = "ru-central1-b"
  allow_stopping_for_update = true
  
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-nginx2.id
    security_group_ids = [yandex_vpc_security_group.inside.id]
    ip_address         = "192.168.20.100"
  }
  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}


resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-bastion.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion-sg.id]
    ip_address         = "192.168.40.100"
  }
  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"
  
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-inside.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.zabbix-sg.id, yandex_vpc_security_group.inside.id]
    ip_address         = "192.168.30.102"
  }
  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}


resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"
  
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }
  
  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-inside.id
    security_group_ids = [yandex_vpc_security_group.zabbix-sg.id, yandex_vpc_security_group.inside.id]
    ip_address         = "192.168.30.101"
  }
  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"
  
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-inside.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana-sg.id, yandex_vpc_security_group.inside.id]
    ip_address         = "192.168.30.103"
  }
  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}


