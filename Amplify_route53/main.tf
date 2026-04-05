module "amplify" {
  source = "./modules/amplify"

  project_name = var.project_name
  repo_name    = var.repo_name
  domain_name  = var.domain_name
  env          = var.env
  branch_name  = var.branch_name
}

module "dns" {
  source = "./modules/dns"

  domain_name        = var.domain_name
  env                = var.env
  amplify_domain_dns = module.amplify.domain_dns
  zone_id            = var.zone_id
}
