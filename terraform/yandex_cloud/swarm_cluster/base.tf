data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

data "yandex_iam_service_account" "yandex" {
  name = "yandex"
}

data "yandex_resourcemanager_folder" "default" {
  folder_id = "b1gvvrumuappv2nqht7i"
}

data "yandex_vpc_network" "swarm" {
  network_id = "enpktiskot4on2aa5ems"
}

data "yandex_vpc_subnet" "swarm" {
  subnet_id = "e2lgnked6q12v5dompd0"
}

