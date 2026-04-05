variable "domain_name" {
  type        = string
  description = "This is the hosted zone for domain name"
}

variable "env" {
  type        = string
  description = "Environment"
}


variable "project_name" {
  type        = string
  description = "name of project"
}

variable "region" {
  type        = string
  description = "aws region "
}

variable "repo_name" {
  type        = string
  description = "Repo Name"
}

variable "branch_name" {
  type        = string
  description = "github branch name"
}

variable "zone_id" {
  type        = string
  description = "zone id"

}