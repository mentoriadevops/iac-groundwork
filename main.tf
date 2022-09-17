provider "google" {
  project = "mentoriaiac-20220916"
  region  = "us-central1"
}

resource "google_compute_network" "vpc" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "load-balance" {
  name          = "load-balance"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc.id

}

resource "google_compute_subnetwork" "nomad" {
  name          = "nomad"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.vpc.id

}

