# Certificate Authority Service (CAS) and TrustConfig

The module allows you to create a CAs/CA pool and trusconfig.

## Prerequisites

 Enable APIs

```
   gcloud services enable privateca.googleapis.com
   gcloud services enable certificatemanager.googleapis.com
   gcloud services enable networksecurity.googleapis.com
```

### Usage

Declare these variables to call the module

```hcl
variable "nb_project_id" {
  description = "Project id of Northbound project"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "ca_pool_name" {
  type = string
}

variable "ca_id" {
  type = string
}

variable "ca_organization" {
  type = string
}

variable "ca_common_name" {
  type = string
}

variable "ca_dns_names" {
  type = list(string)
}

variable "trustconfig_name" {
  type = string
}


variable "policy_name_strict" {
  type = string
}

variable "policy_name_lenient" {
  type = string
}

```

Call the module

```hcl
module "ca_infrastructure" {
  source              = "./modules/cert-auth-service"
  project_id          = var.nb_project_id
  project_number      = var.nb_project_number
  region              = var.region
  ca_pool_name        = var.ca_pool_name
  ca_id               = var.ca_id
  ca_organization     = var.ca_organization
  ca_common_name      = var.ca_common_name
  ca_dns_names        = var.ca_dns_names
  client_certificates = var.client_certificates
  trustconfig_name    = var.trustconfig_name
  env                 = var.env
  policy_name_strict  = var.policy_name_strict
  policy_name_lenient = var.policy_name_lenient
}
```

## Setup Instructions

```
terraform validate
terraform init
terraform apply -var-file=terraform.tfvars
```

|resource | description |
|---|---|
| ca pool | (Certificate Authority Pool) in Google Cloud Platform (GCP) is a collection of Certificate Authorities (CAs) that are managed together under a single logical group | 
| ca root | A Root Certificate Authority (Root CA) is the top-most entity in a Public Key Infrastructure (PKI) hierarchy, responsible for issuing and signing digital certificates|
|Trust config | A TrustConfig in Google Cloud Platform (GCP) is a configuration resource that defines the trust settings for mutual TLS (mTLS) connections within your network. |
| Policies | strict and lenient |
