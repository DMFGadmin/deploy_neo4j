output "neo4j-external-address" {
  value = google_compute_address.neo4j-external-access.address
}

output "neo4j-server" {
  value = google_compute_instance.neo4j-server.name
}

output  "neo4j-server-network-tags" {
  value = google_compute_instance.neo4j-server.tags
}