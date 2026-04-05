variable "vpc_cidr_block" {
  type        = string
  description = "This is the vpc cidr block"
}

variable "project_name" {
  type        = string
  description = "this is project name"
}

variable "aws_region" {
  type = string
}

variable "pub_sub_1a_cidr" {
  type = string
}

variable "pub_sub_2b_cidr" {}

variable "pri_sub_3a_cidr" {}

variable "pri_sub_4b_cidr" {}

variable "pri_sub_5a_cidr" {}

variable "pri_sub_6b_cidr" {}