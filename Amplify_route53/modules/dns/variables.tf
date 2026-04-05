variable "domain_name" {
  type        = string
  description = "The hosted zone domain name"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "amplify_domain_dns" {
  type        = list(string)
  description = "Amplify domain DNS records"
}

variable "zone_id" {
  type        = string
  description = "zone id"

}