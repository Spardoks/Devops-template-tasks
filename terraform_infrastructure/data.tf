
# VMS master

data "yandex_compute_image" "ubuntu-master" {
  family = var.os_image_master
}

data "template_file" "cloudinit-master" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    ssh_public_key = local.ssh-keys
    ssh_private_key = local.ssh-private-keys
    hostname = "master"
  }
}

# VMS worker

data "yandex_compute_image" "ubuntu-worker" {
  family = var.os_image_worker
}

data "template_file" "cloudinit-worker" {
  count = var.worker_count
  template = file("${path.module}/cloud-init.yml")
  vars = {
    ssh_public_key = local.ssh-keys
    ssh_private_key = local.ssh-private-keys
    hostname = "worker-${count.index + 1}"
  }
}