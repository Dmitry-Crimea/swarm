
resource "yandex_compute_instance" "vm-2" {
#  name        = "linux-vm"      # Имя нашей виртуалки
  platform_id = "standard-v3"   # на какой серверной платформе будет создан наш инстанс
  zone        = "ru-central1-b" # Зона доступности
  count       = 3               # Создайём 3 виртуальные машины

  resources {
    cores  = 2 # Количество ядер
    memory = 4 # Объём оперативной памяти
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id # ID образа нашей виртуальной машины
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
  zone           = yandex_compute_instance.zone
  network_id     = yandex_vpc_network.swarm-network.id
  v4_cidr_blocks = var.swarm-subnet
}