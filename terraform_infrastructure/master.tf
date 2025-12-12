
resource "yandex_compute_instance" "master" {
  name        = "${var.yandex_compute_instance_master.vm_name}"
  platform_id = var.yandex_compute_instance_master.platform_id
  allow_stopping_for_update = true
  count = 1
  zone = var.zone1
  resources {
    cores         = var.yandex_compute_instance_master.cores
    memory        = var.yandex_compute_instance_master.memory
    core_fraction = var.yandex_compute_instance_master.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-master.image_id
      type     = var.boot_disk_master.type
      size     = var.boot_disk_master.size
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
    user-data          = data.template_file.cloudinit-master.rendered
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.network1-subnet1.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
}