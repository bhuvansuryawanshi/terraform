variable "project_name" {
  type = string
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

variable "sg_id" {
  type = string

}

variable "tg_arn" {
  type = string

}
variable "private_subnet_ids" {
  type = list(string)

}