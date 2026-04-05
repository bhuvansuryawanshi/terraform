
variable "project_name" {
  type = string
}
variable "vpc_cidr" {
  type        = string
  description = "vpc cidr variable"
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