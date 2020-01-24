resource "google_compute_address" "neo4j-external-access" {
  name    =  "jenkins-external-access-address"
  address_type = "EXTERNAL"
  description = "Used to access a neo4j instance remotely"
  network_tier = "PREMIUM"
  region      = var.region
  project     = var.project_id
}

resource "google_compute_instance" "neo4j-server" {
  name         = "afrl-neo4j-server-001"
  project = var.project_id
  machine_type = "n1-standard-2"
  tags = ["${var.neo4j_access_source_tags}"]

  zone = var.zone

  boot_disk {
    initialize_params {
      image = "projects/${var.project_id}/global/images/afrl-neo4j-image"
      size = 10
      type  = "pd-standard"
    }
  }


  network_interface {
    subnetwork = "projects/${var.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"

    access_config {
      nat_ip = google_compute_address.neo4j-external-access.address
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_firewall" "allow-traffic-for-iap" {
  name = "allow-traffic-from-iap"
  description = "Allow IAP traffic"
  network =   var.network
  direction = "INGRESS"
  project = var.project_id
  disabled = "false"
  priority = 1000
  enable_logging = "false"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["${var.iap_source_address_cidr}"]
  target_tags = ["${var.neo4j_access_source_tags}"]
