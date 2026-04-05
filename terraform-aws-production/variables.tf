variable "project_name" {
  type        = string
  description = "project name"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block"
}

variable "availability_zones" {
  type        = list(string)
  description = "availability zones"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "public subnet cidr"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "private subnet cidr"
}

variable "ami_id" {
  type = string

}
variable "instance_type" {
  type = string

}

variable "key_name" {
  type = string

}

