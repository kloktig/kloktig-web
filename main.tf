terraform {
  cloud {
    organization = "kloktig"
    workspaces {
      name = "kloktig-web"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.location
  credentials = var.google_sa
}

terraform {
  required_version = ">= 0.14"

  required_providers {
    # Cloud Run support was added on 3.3.0
    google = ">= 3.3"
  }
}

resource "google_container_registry" "registry" {
  location = "EU"
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

resource "google_cloud_run_service" "run_service" {
  name     = "api"
  location = var.location
  depends_on = [
    google_project_service.run_api
  ]

  template {
    spec {
      containers {
        image = "gcr.io/google-samples/hello-app:1.0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "service_url" {
  value = google_cloud_run_service.run_service.status[0].url
}

output "google_container_bucket_link" {
  value = google_container_registry.registry.id
}
