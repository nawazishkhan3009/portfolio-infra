output "cluster_name" {
  value = google_container_cluster.portfolio.name
}

output "cluster_endpoint" {
  value     = google_container_cluster.portfolio.endpoint
  sensitive = true
}

output "static_ip" {
  value = google_compute_address.portfolio_ip.address
}