# Production AWS Infrastructure with CloudFront

A production-grade AWS setup with a custom VPC, ALB-backed Auto Scaling Group, and a CloudFront distribution as the global CDN layer in front of the ALB.

## Architecture

```
Internet
   │
   ▼
[CloudFront CDN] (global edge, PriceClass_100)
   │
   ▼
[ALB] (public subnets)
   │
   ▼
[ASG - EC2 Instances] (private subnets)
```

## Modules

| Module | Description |
|---|---|
| `vpc` | Custom VPC with public and private subnets across multiple AZs |
| `sg` | Security groups for the ALB and EC2 instances |
| `alb` | Application Load Balancer in public subnets |
| `asg` | Auto Scaling Group of EC2 instances in private subnets |
| `cf` | CloudFront distribution pointing to the ALB as its origin |

## CloudFront Details

- Origin: ALB via HTTP (port 80)
- Default root object: `index.html`
- Price class: `PriceClass_100` (North America & Europe edge locations — most cost-effective)
- No geo-restrictions
- Uses default CloudFront SSL certificate

## Outputs

| Output | Description |
|---|---|
| `cf_domain_name` | CloudFront distribution domain name (use this as your app URL) |

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Key Variables

| Variable | Description |
|---|---|
| `project_name` | Name prefix for all resources |
| `vpc_cidr` | CIDR block for the custom VPC |
| `availability_zones` | List of AZs to deploy into |
| `public_subnet_cidr` | CIDR blocks for public subnets |
| `private_subnet_cidr` | CIDR blocks for private subnets |
| `ami_id` | AMI ID for EC2 instances in the ASG |
| `instance_type` | EC2 instance type |
| `key_name` | SSH key pair name for EC2 access |

Set values in `terraform.tfvars` (not committed to git).
