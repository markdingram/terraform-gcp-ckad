provider "google" {
  project = "ckad-cluster-mdi"
  region  = "europe-west1"
}

resource "google_container_cluster" "primary" {
  name     = "ckad-cluster-mdi"
  location = "europe-west1-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "ckad-cluster-mdi-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = "europe-west1-a"

  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-micro"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
