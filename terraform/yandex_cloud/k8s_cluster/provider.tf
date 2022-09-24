# Подключаем провайдера Яндекс
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Указываем Credentials, а так же сервисные данные.
provider "yandex" {
  zone  = var.zone
  service_account_key_file = var.service_account_key_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}