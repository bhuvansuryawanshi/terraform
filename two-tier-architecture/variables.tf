variable "project_name" {
  description = "This is the project variable"
  type        = string
}

variable "aws_region" {
  description = "this is the region code"
  type        = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "pub_sub_1a_cidr" {
  type        = string
  description = "public subnet 1a "
}

variable "pub_sub_2b_cidr" {
  type        = string
  description = "public subnet 1a "
}

variable "pri_sub_3a_cidr" {
  type        = string
  description = "private subnet 3a "
}

variable "pri_sub_4b_cidr" {
  type        = string
  description = "private subnet 4b"
}

variable "pri_sub_5a_cidr" {
  type        = string
  description = "private subnet 5a "
}

variable "pri_sub_6b_cidr" {
  type        = string
  description = "private subnet 6b "
}