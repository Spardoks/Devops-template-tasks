
# Basic

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


# Network

variable "zone1" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "cidr1" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cidr2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "network1"
  description = "VPC network name"
}

variable "subnet1" {
  type        = string
  default     = "network1-subnet1"
  description = "VPC subnet name"
}

variable "subnet2" {
  type        = string
  default     = "network1-subnet2"
  description = "VPC subnet name"
}


# VMS general

locals {
  ssh-keys = fileexists("~/.ssh/id_ed25519.pub") ? file("~/.ssh/id_ed25519.pub") : var.ssh_public_key
  ssh-private-keys = fileexists("~/.ssh/id_ed25519") ? file("~/.ssh/id_ed25519") : var.ssh_private_key
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = ""
}

variable "ssh_private_key" {
  description = "SSH private key"
  type        = string
  default     = ""
}


# VMS master

variable "os_image_master" {
  type    = string
  default = "ubuntu-2404-lts"
}

variable "yandex_compute_instance_master" {
  type        = object({
    vm_name = string
    cores = number
    memory = number
    core_fraction = number
    count_vms = number
    platform_id = string
  })

  default = {
      vm_name = "master"
      cores         = 2
      memory        = 4
      core_fraction = 5
      count_vms = 1
      platform_id = "standard-v1"
    }
}

variable "boot_disk_master" {
  type        = object({
    size = number
    type = string
  })
  default = {
    size = 10
    type = "network-hdd"
  }
}


# VMS worker

variable "os_image_worker" {
  type    = string
  default = "ubuntu-2404-lts"
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "worker_resources" {
  type = object({
    cpu         = number
    ram         = number
    disk        = number
    core_fraction = number
    platform_id = string
  })
  default = {
    cpu         = 4
    ram         = 8
    disk        = 10
    core_fraction = 10
    platform_id = "standard-v1"
  }
}
