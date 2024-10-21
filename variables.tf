variable "project_id" {
  type = string
}

variable "project_number" {
  type = string
}

variable "region" {
  type = string
}

variable "env" {
  type = string
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

variable "ca_issuance_name" {
  description = "GCP ca issuance"
  type        = string
}
