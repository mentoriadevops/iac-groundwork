provider "google" {
  project = "mentoria-iac-staging"
  region  = "us-central1"
}

# VPC
resource "google_compute_network" "groundwork" {
  name                    = "groundwork"
  auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "load_balancer" {
  name          = "load-balancer"
  ip_cidr_range = "10.2.1.0/24"
  network       = google_compute_network.groundwork.id
}

resource "google_compute_subnetwork" "nomad" {
  name          = "nomad"
  ip_cidr_range = "10.2.2.0/24"
  network       = google_compute_network.groundwork.id
}

# NAT
resource "google_compute_router" "nat" {
  name    = "groundwork"
  network = google_compute_network.groundwork.id
}

resource "google_compute_router_nat" "nat" {
  name                   = "groundwork-nat"
  router                 = google_compute_router.nat.name
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.nomad.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Firewall
resource "google_compute_firewall" "allow_internal" {
  name          = "allow-internal"
  network       = google_compute_network.groundwork.name
  source_ranges = ["10.2.0.0/22"]

  # Define como prioridade baixa para permitir que outras regras sobreescrevam
  # para casos mais específicos.
  priority = 65534

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}
