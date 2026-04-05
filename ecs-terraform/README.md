# ECS Fargate on AWS

Deploys a containerized application (Flask) on AWS ECS Fargate using the default VPC. Includes ECR for storing the Docker image, an ALB for routing traffic, and CloudWatch for logging.

## Architecture

```
Internet
   │
   ▼
[ALB] (default VPC subnets)
   │
   ▼
[ECS Fargate Service] (awsvpc networking, ARM64)
   │
[ECR] ← Docker image pulled at task startup
   │
[CloudWatch Logs] ← Container stdout/stderr
```

## Modules

| Module | Description |
|---|---|
| `ecr` | Creates an ECR repository to store the Docker image |
| `ecs` | Creates ECS cluster, Fargate task definition, ECS service, ALB, target group, security groups, IAM execution role, and CloudWatch log group |

## Notable Details

- Runs on **Fargate** (serverless, no EC2 to manage)
- Task platform: **ARM64 / Linux** (optimized for Graviton-based builds)
- Logs retained for **7 days** in CloudWatch
- Uses the **default VPC** (no custom VPC provisioned)
- IAM task execution role uses `AmazonECSTaskExecutionRolePolicy`

## Usage

```bash
# Build and push your Docker image to ECR first
terraform init
terraform plan
terraform apply
```

## Key Variables

| Variable | Description |
|---|---|
| `project-name` | Name prefix for all resources |
| `env` | Environment (e.g. dev, prod) |
| `region` | AWS region |
| `container_port` | Port the container listens on |
| `cpu` / `memory` | Fargate task CPU units and memory (MB) |
| `desired_count` | Number of running ECS tasks |
| `image_tag` | Docker image tag to deploy from ECR |

Set values in `terraform.tfvars` (not committed to git).
