variable "region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "default-ec2-instance"
}

variable "key_name" {
  description = "Name of an existing SSH key pair in AWS"
  type        = string
  default     = ""
}

# Root volume (EBS)
variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "EBS volume type: gp2, gp3, io1, io2, etc."
  type        = string
  default     = "gp3"
}

variable "root_volume_iops" {
  description = "IOPS for root volume (used when root_volume_type is gp3 or io1/io2)"
  type        = number
  default     = 3000
}

variable "root_volume_throughput" {
  description = "Throughput in MiB/s for gp3 root volume"
  type        = number
  default     = 125
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = false
}

variable "app_secret_names" {
  description = "List of secret names to create in AWS Secrets Manager. Values must be added manually via AWS Console."
  type        = list(string)
  default     = []
}
