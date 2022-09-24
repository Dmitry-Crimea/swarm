#Создаём VPC для нашего swarm кластера
resource "yandex_compute_instance_group" "swarm" {
  name                    = "swarm"      # Имя нашей виртуалки
  folder_id               = "${data.yandex_resourcemanager_folder.default.id}"
  service_account_id      = "${data.yandex_iam_service_account.yandex.id}"
  deletion_protection     = false
  instance_template {
    platform_id           = "standard-v1"   # на какой серверной платформе будет создан наш инстанс
    resources {
      cores  = 2 # Количество ядер
      memory = 4 # Объём оперативной памяти
    }
    # ID образа нашей виртуальной машины
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${data.yandex_compute_image.ubuntu_image.id}"
        size     = 20
      }
    }
    network_interface {
      network_id = "${data.yandex_vpc_network.swarm.id}" #ID Сети
      subnet_ids = ["${data.yandex_vpc_subnet.swarm.id}"] #D подсетей, к которым нужно подключить этот интерфейс
      nat = true
    }

    metadata = {
      user-data = "${"file(var.user_account)"}"
    }
  }
    # Количество нод в кластере
    scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-b"]
  }
  deploy_policy {
    max_unavailable = 1 #Максимальное количество запущенных экземпляров, которые могут быть переведены в автономный режим (остановлены или удалены) одновременно. в процессе обновления.
    max_creating    = 1 # Максимальное количество экземпляров, которые можно создать одновременно.
    max_expansion   = 1 #Максимальное количество экземпляров, которые могут быть временно выделены сверх целевого размера группы. в процессе обновления.
    max_deleting    = 2 #Максимальное количество экземпляров, которые можно удалить одновременно.
  }
}

#Создаём VPC для нашего NFS
resource "yandex_compute_instance" "nfs" {
  name        = "nfs storage"      # Имя нашей виртуалки
  platform_id = "standard-v1"   # на какой серверной платформе будет создан наш инстанс
  zone        = "ru-central1-b" # Зона доступности

  resources {
    cores  = 2 # Количество ядер
    memory = 4 # Объём оперативной памяти
  }

  # ID образа нашей виртуальной машины
  boot_disk {
    mode = "READ_WRITE" # Режим работы диска
    initialize_params {
      image_id = "${data.yandex_compute_image.ubuntu_image.id}"
      size     = 20  # Размер диска для нашего инстанса
    }
  }

  network_interface {
    subnet_id = var.network_interface
    nat       = true
  }

  metadata = {
    user-data = "${"file(var.user_account)"}"
  }
}

#Создаем сеть для кластера
resource "yandex_vpc_network" "swarm-network" {
  name = "swarm-net"
}

#Создаем подсеть для кластера
resource "yandex_vpc_subnet" "swarm-subnet" {
  name           = "swarm-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.swarm-network.id
  v4_cidr_blocks = var.swarm-subnet
}