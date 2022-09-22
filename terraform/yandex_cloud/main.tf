terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  zone  = "ru-central1-b"
#  token = "t1.9euelZqYxpTLmoqXyMyKyJXIzszPl-3rnpWax42RiZfJy5DLxpLIj83Nycbl8_d8ElRm-e84F2pb_d3z9zxBUWb57zgXalv9zef1656VmoyMyM6Yy8qQys3GjIqPyYnJ7_0.0axzuOXP8Og1dAU-ZPbH1j9DKGHOBZM2YQUGQuADBQPbc9YgWgvTauLOYvkCtZxrAFQG1jiungjzF1ttFxb0Bw"
    service_account_key_file = "/home/it/key.json"
  cloud_id  = "b1gtefj6a3lvmcbuo02r"
  folder_id = "b1gvvrumuappv2nqht7i"
}

resource "yandex_compute_instance" "vm-1" {
  name        = "linux-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8lbi4hr72am1eb2kmf"
    }
  }

  network_interface {
    subnet_id = "e2lgnked6q12v5dompd0"
    nat       = true
  }

  metadata = {
    user-data = "
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}