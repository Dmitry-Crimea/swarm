# Файл с пользовательскими данными. В частности в этом файле указаны имя пользователя
# и SSH ключ, для доступа на наши VPC по SSH, а так же создаем пользователя.
variable "user_account" {
  description = "user account"
  default = "./user-data/user_account"
}

# Ключевой файл от сервис аккаунта, его нужно создать на вкладке ресурсов,
# нужен для авторизации провайдера
variable "service_account_key_file" {
  description = "YC - service_account_key_file"
  default     = "/home/it/key.json"
}

# Зона доступности, в которой будут созданы наши VPC
variable "zone" {
  description = "zone of availability"
  default     = "ru-central1-b"
}

#ID образа нашей виртуальной машины
variable "image_id" {
  description = "Image ID"
  default     = "fd8lbi4hr72am1eb2kmf"

}

#ID самого облака Яндекс, в котором будем работать
variable "cloud_id" {
  description = "cloud id"
  default     = "b1gtefj6a3lvmcbuo02r"
}

#ID директории проекта в облаке, в котором будут находится наши VPC
variable "folder_id" {
  description = "folder id"
  default     = "b1gvvrumuappv2nqht7i"
}

#ID сетевого интерфейса
variable "network_interface" {
  description = "subnet_id"
  default     = "e2lgnked6q12v5dompd0"
}

#Подсеть для кластера
variable "swarm-subnet" {
  description = "subnet_id"
  default     = ["192.168.10.0/24"]
}