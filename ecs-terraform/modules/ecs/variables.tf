variable "project-name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}
variable "ecr_repository_url" {
  type = string
}

# Port your app listens on (inside container)
variable "container_port" {
  type    = number
  default = 8000
}

variable "desired_count" {
  type    = number
  default = 1
}

# Fargate task CPU/memory
variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}
# Optional: set tag to use image (CI can update task definition or override)
variable "image_tag" {
  type    = string
  default = "latest"
}
