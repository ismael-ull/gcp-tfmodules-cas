#CA Pool
resource "google_privateca_ca_pool" "default" {
  name     = var.ca_pool_name
  project  = var.project_id
  location = var.region
  tier     = "ENTERPRISE"
  publishing_options {
    publish_ca_cert = true
    publish_crl     = true
  }
}


#CA Authority
resource "google_privateca_certificate_authority" "default" {
  location                 = var.region
  project                  = var.project_id
  pool                     = google_privateca_ca_pool.default.name
  certificate_authority_id = var.ca_id
  config {
    subject_config {
      subject {
        organization = var.ca_organization
        common_name  = var.ca_common_name
      }
      subject_alt_name {
        dns_names = var.ca_dns_names
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign  = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }

  // Disable CA deletion related safe checks for easier cleanup.
  deletion_protection                    = false
  skip_grace_period                      = true
  ignore_active_certificates_on_deletion = true
}

resource "tls_private_key" "cert_key" {
  algorithm = "RSA"
}


######################################################################
#                      TrustConfig                                   #
######################################################################


#TrustConfig
resource "google_certificate_manager_trust_config" "default" {
  name     = var.trustconfig_name
  location = "global"
  project  = var.project_id

  trust_stores {
    trust_anchors {
      pem_certificate = google_privateca_certificate_authority.default.pem_ca_certificates[0]
    }
    #intermediate_cas {
    #  pem_certificate = file("test-fixtures/cert.pem")
    #}
  }
}

#Policies
resource "google_network_security_server_tls_policy" "strict" {
  project  = var.project_id
  provider = google-beta
  name     = var.policy_name_strict

  description = "Policy for strict"
  location    = "global"
  allow_open  = "false"

  mtls_policy {
    client_validation_mode         = "REJECT_INVALID"
    client_validation_trust_config = "projects/${var.project_number}/locations/global/trustConfigs/${google_certificate_manager_trust_config.default.name}"
  }

  labels = {
    env = var.env
  }
}


resource "google_network_security_server_tls_policy" "lenient" {
  project  = var.project_id
  provider = google-beta
  name     = var.policy_name_lenient

  description = "Policy for lenient"
  location    = "global"
  allow_open  = "false"

  mtls_policy {
    client_validation_mode         = "ALLOW_INVALID_OR_MISSING_CLIENT_CERT"
    client_validation_trust_config = "projects/${var.project_number}/locations/global/trustConfigs/${google_certificate_manager_trust_config.default.name}"
  }

  labels = {
    env = var.env
  }
}


##########################################################
# Certificate issuance config
##########################################################

resource "google_certificate_manager_certificate_issuance_config" "ca_issuance_own" {
  name     = var.ca_issuance_name
  project  = var.project_id
  location = "global"
  certificate_authority_config {
    certificate_authority_service_config {
      ca_pool = google_privateca_ca_pool.default.id
    }
  }
  lifetime                   = "2592000s"
  rotation_window_percentage = "66"         # Lifetime of the certificate (1 day = 86400 seconds)
  key_algorithm              = "ECDSA_P256" # Key algorithm (options: ECDSA_P256, ECDSA_P384, RSA_PSS_2048_SHA256, RSA_PSS_4096_SHA256)
}

resource "google_project_service_identity" "cert_manager_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "certificatemanager.googleapis.com"
}

resource "google_privateca_ca_pool_iam_member" "sbx_auto_ca_pool_binding" {
  ca_pool  = google_privateca_ca_pool.default.id
  location = var.region # Location of your CA pool
  role     = "roles/privateca.certificateRequester"
  member   = "serviceAccount:${google_project_service_identity.cert_manager_sa.email}"
}
