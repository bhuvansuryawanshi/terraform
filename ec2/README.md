# EC2 Instance (Quick Deploy)

A simple, reusable Terraform config to spin up a single EC2 instance in the default VPC. Useful for quick experiments, dev environments, or running one-off workloads without setting up a full VPC.

## What It Creates

- EC2 instance using the **latest Amazon Linux 2023 AMI** (auto-discovered)
- Placed in the **default VPC** and one of its default subnets
- Attached to the **default security group**
- Configurable **EBS root volume** (size, type, IOPS, throughput, encryption)
- Bootstrapped via `user_data.sh` on first launch
- Optional SSH key pair attachment

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Key Variables

| Variable | Description | Default |
|---|---|---|
| `region` | AWS region | — |
| `instance_type` | EC2 instance type | `t2.micro` |
| `instance_name` | Name tag for the instance | `default-ec2-instance` |
| `key_name` | Existing AWS key pair name for SSH | `""` (no key) |
| `root_volume_size` | Root EBS volume size in GB | `20` |
| `root_volume_type` | EBS type (`gp2`, `gp3`, etc.) | `gp3` |
| `root_volume_iops` | IOPS (for `gp3`/`io1`/`io2`) | `3000` |
| `root_volume_throughput` | Throughput in MiB/s (for `gp3`) | `125` |
| `root_volume_encrypted` | Encrypt root volume | `false` |

Set values in `terraform.tfvars` (not committed to git).

## Notes

- The AMI is always resolved to the latest `al2023-ami-*-x86_64` at plan time
- `user_data.sh` runs on first boot — edit it to install packages or configure the instance
- A `keyPair.pem` file may exist locally — **never commit this to git**
