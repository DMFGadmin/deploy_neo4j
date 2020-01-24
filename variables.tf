
variable "project_id" {
  description = "The project ID to deploy in to"
}

variable "region" {
  description = "The region to deploy to"
  default     = "us-central1"
}

variable "network" {
  description = "The GCP network to launch the instance in"
}

variable "subnetwork" {
  description = "The GCP subnetwork to launch the instance in"
}

variable "neo4j_access_source_tags" {
  description = "firewall tags to allow access to jenkins server"
}

variable "zone" {
  description = "what zone should this server be deployed in?"
}

variable "network_project_id" {
  description  =  "the project that hosts the network"
}