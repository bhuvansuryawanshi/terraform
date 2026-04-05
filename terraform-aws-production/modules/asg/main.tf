# LAUNCH TEMPLATE
resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # vpc_security_group_ids = [var.sg_id]

  # Private instances → no public IP
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_id]
    delete_on_termination       = true
  }

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-ec2"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  monitoring {
    enabled = true
  }

}

# AUTO SCALING GROUP
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project_name}-asg"
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Use private subnets
  vpc_zone_identifier = var.private_subnet_ids

  # Attach Launch Template
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  # Attach to ALB target group for HTTP (optional)
  target_group_arns = [var.tg_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

