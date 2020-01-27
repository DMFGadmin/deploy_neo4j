variable "region" {
  description = "The region to deploy to"
  default     = "us-central1"
}

variable "neo4j_access_source_tags" {
  description = "firewall tags to allow access to jenkins server"
}

variable "zone" {
  description = "what zone should this server be deployed in?"
}

variable "project_id" {
  description = "project to deploy neo4j into"
}