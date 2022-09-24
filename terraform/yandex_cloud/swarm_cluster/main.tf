#Создаём VPC для нашего swarm
resource "yandex_compute_instance" "swarm" {
  count       = var.node_count                # Количество нод в кластере
  name        = "sworm-${count.index}"  # Имя нашей виртуалки
  platform_id = "standard-v1"                 # на какой серверной платформе будет создан наш инстанс
  zone        = "ru-central1-b"               # Зона доступности
#  tags        = ["swarm"]

  resources {
    cores  = 2                                # Количество ядер
    memory = 4                                # Объём оперативной памяти
  }

  # ID образа нашей виртуальной машины
  boot_disk {
    mode = "READ_WRITE"                       # Режим работы диска
    initialize_params {
      image_id = "${data.yandex_compute_image.ubuntu_image.id}"
      size     = var.disk_size                # Размер диска для нашего инстанса
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


#Создаём VPC для нашего NFS
resource "yandex_compute_instance" "nfs" {
  name        = "nfs-storage"                # Имя нашей виртуалки
  platform_id = "standard-v1"                # на какой серверной платформе будет создан наш инстанс
  zone        = "ru-central1-b"              # Зона доступности
#  tags        = ["nfs"]

  resources {
    cores  = 2                               # Количество ядер
    memory = 4                               # Объём оперативной памяти
  }

  # ID образа нашей виртуальной машины
  boot_disk {
    mode = "READ_WRITE"                      # Режим работы диска
    initialize_params {
      image_id = "${data.yandex_compute_image.ubuntu_image.id}"
      size     = 20                          # Размер диска для нашего инстанса
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