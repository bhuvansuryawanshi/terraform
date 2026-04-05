# Two-Tier Architecture on AWS

A production-style two-tier AWS architecture using Terraform modules. Deploys a VPC with public/private subnets, an Application Load Balancer in the public tier, and an Auto Scaling Group of EC2 instances in the private tier.

## Architecture

```
Internet
   │
   ▼
[ALB] (public subnets: 1a, 2b)
   │
   ▼
[ASG - EC2 Instances] (private subnets: 3a, 4b)
   │
[NAT Gateway] → Internet (for outbound traffic from private subnets)
   │
[Private DB Subnets] (5a, 6b) — reserved for RDS/database tier
```

## Modules

| Module | Description |
|---|---|
| `vpc` | Creates VPC with 2 public, 4 private subnets across 2 AZs |
| `nat` | NAT Gateways in each public subnet for private subnet egress |
| `security_group` | ALB security group (public) and EC2 client security group (private) |
| `key` | Generates an SSH key pair for EC2 instance access |
| `alb` | Application Load Balancer with target group in public subnets |
| `asg` | Auto Scaling Group of EC2 instances in private subnets, registered to the ALB target group |

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
| `aws_region` | AWS region to deploy into |
| `vpc_cidr_block` | CIDR block for the VPC |
| `pub_sub_1a_cidr` / `pub_sub_2b_cidr` | Public subnet CIDRs |
| `pri_sub_3a_cidr` / `pri_sub_4b_cidr` | Private app subnet CIDRs |
| `pri_sub_5a_cidr` / `pri_sub_6b_cidr` | Private DB subnet CIDRs |

Set values in `terraform.tfvars` (not committed to git).
