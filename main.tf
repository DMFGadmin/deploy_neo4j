data "terraform_remote_state" "project-and-networks" {
  backend = "remote"
  config = {
    organization = "AFRLDigitalMFG"
    workspaces = {
      name = "shared_vpc_projects"
    }
  }
}

resource "google_compute_address" "neo4j-external-access" {
  name    =  "neo4j-external-access-address"
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
    subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${data.terraform_remote_state.project-and-networks.outputs.afrl-shared-vpc-subnet-1}"

    access_config {
      nat_ip = google_compute_address.neo4j-external-access.address
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}