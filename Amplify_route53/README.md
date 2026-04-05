# AWS Amplify + Route53 Custom Domain

Connects an AWS Amplify app to a custom domain using Route53. Automates the DNS setup that you would otherwise do manually in the AWS Console.

## Architecture

```
User's Browser
   │
   ▼
[Route53] (custom domain DNS)
   │  (CNAME → Amplify domain)
   ▼
[AWS Amplify] (hosts the frontend app from a GitHub branch)
```

## Modules

| Module | Description |
|---|---|
| `amplify` | Creates an Amplify app connected to a GitHub repo and sets up a custom domain on a specific branch |
| `dns` | Creates a Route53 CNAME record pointing the custom domain to the Amplify-provided domain DNS |

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> After apply, Amplify may take a few minutes to verify and activate the custom domain SSL certificate.

## Key Variables

| Variable | Description |
|---|---|
| `project_name` | Name of the Amplify app |
| `repo_name` | GitHub repository name |
| `domain_name` | Custom domain (e.g. `example.com`) |
| `env` | Environment label (e.g. `dev`, `prod`) |
| `branch_name` | Git branch to deploy (e.g. `main`) |
| `zone_id` | Route53 Hosted Zone ID for the domain |

Set values in `terraform.tfvars` (not committed to git).
