output "trust_config_id" {
  description = "The ID of the certificate manager trust config."
  value       = google_certificate_manager_trust_config.default.id
}

output "trust_config_name" {
  description = "The name of the certificate manager trust config."
  value       = google_certificate_manager_trust_config.default.name
}

output "trust_config_location" {
  description = "The location of the certificate manager trust config."
  value       = google_certificate_manager_trust_config.default.location
}

output "trust_config_project" {
  description = "The project ID of the certificate manager trust config."
  value       = google_certificate_manager_trust_config.default.project
}

output "issuance_config_id" {
  description = "The project ID of the issuance config."
  value       = google_certificate_manager_certificate_issuance_config.ca_issuance_own.id
}

output "ca_pool_id" {
  description = "The project ID of the ca pool."
  value       = google_privateca_ca_pool.default.id
}
