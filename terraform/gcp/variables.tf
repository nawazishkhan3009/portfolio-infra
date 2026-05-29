variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for the cluster"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone for the cluster"
  type        = string
  default     = "europe-west1-b"
}