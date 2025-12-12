output "all_vms" {
  value = flatten([
    [
      {
        name        = yandex_compute_instance.master[0].name
        ip_external = yandex_compute_instance.master[0].network_interface[0].nat_ip_address
        ip_internal = yandex_compute_instance.master[0].network_interface[0].ip_address
      }
    ],
    [for i in yandex_compute_instance.worker : {
      name = i.name
      ip_external   = i.network_interface[0].nat_ip_address
      ip_internal = i.network_interface[0].ip_address
    }]
  ])
}