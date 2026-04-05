# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Default subnets in the default VPC (use first one)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Default security group for the default VPC
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [data.aws_security_group.default.id]
  key_name               = var.key_name != "" ? var.key_name : null

  # Root volume (EBS)
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    iops                  = var.root_volume_type == "gp3" ? var.root_volume_iops : null
    throughput            = var.root_volume_type == "gp3" ? var.root_volume_throughput : null
    encrypted             = var.root_volume_encrypted
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }

  user_data = file("${path.module}/user_data.sh")
}


# secret manager for env
# resource "aws_secretsmanager_secret" "app_secrets" {
#   for_each    = toset(var.app_secret_names)
#   name        = "/${each.key}"
#   description = "App secret for ${each.key}"
# }

