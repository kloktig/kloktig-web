variable "google_sa" {
  type        = string
  sensitive   = true
  description = "Google Cloud service account credentials"
}

variable "project" {
  type    = string
  default = "kloktig-webpage"
}

variable "location" {
  type    = string
  default = "europe-north1"
}
