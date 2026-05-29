terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required GCP APIs
resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
  ])
  service = each.key
  disable_on_destroy = false
}

# Minimal VPC
resource "google_compute_network" "vpc" {
  name                    = "portfolio-vpc"
  auto_create_subnetworks = true
}

# GKE Standard cluster (free tier eligible: one zonal cluster)
resource "google_container_cluster" "portfolio" {
  name     = "portfolio-gke"
  location = var.zone

  # We want a single node, so set remove_default_node_pool and add a managed node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Free tier automatically waives the management fee for the first zonal cluster
  # but we still set a minimal network config
  network    = google_compute_network.vpc.name
  subnetwork = "" # uses default subnetwork from auto-creation

  # Optional: enable workload identity if you want later
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Managed node pool with a single e2-small node
resource "google_container_node_pool" "primary" {
  name       = "default-pool"
  cluster    = google_container_cluster.portfolio.name
  location   = var.zone
  node_count = 1

  node_config {
    machine_type = "e2-small"    # ~$12.50/month on-demand
    disk_size_gb = 20
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}