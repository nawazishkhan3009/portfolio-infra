output "cluster_name" {
  value = google_container_cluster.portfolio.name
}

output "cluster_endpoint" {
  value     = google_container_cluster.portfolio.endpoint
  sensitive = true
}