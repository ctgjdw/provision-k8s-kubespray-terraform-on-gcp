# Output variables
output "control_plane_names" {
  value       = google_compute_instance.control_plane.*.name
  description = "The names of the control plane instances"
}

output "control_plane_ips" {
  value       = google_compute_instance.control_plane.*.network_interface.0.access_config.0.nat_ip
  description = "The IPs of the control plane instances"
}

output "worker_names" {
  value       = google_compute_instance.worker_nodes.*.name
  description = "The names of the worker instances"
}

output "worker_ips" {
  value       = google_compute_instance.worker_nodes.*.network_interface.0.access_config.0.nat_ip
  description = "The IPs of the worker instances"
}

output "all_instance_names" {
  value       = concat(google_compute_instance.control_plane.*.name, google_compute_instance.worker_nodes.*.name)
  description = "All instance names combined"
}

output "all_instance_ips" {
  value       = concat(google_compute_instance.control_plane.*.network_interface.0.access_config.0.nat_ip, google_compute_instance.worker_nodes.*.network_interface.0.access_config.0.nat_ip)
  description = "All instance IPs combined"
}