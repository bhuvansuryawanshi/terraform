module "ecr" {
  source       = "./modules/ecr"
  project-name = var.project-name
  env          = var.env
  region       = var.region
}

module "ecs" {
  source             = "./modules/ecs"
  project-name       = var.project-name
  env                = var.env
  region             = var.region
  ecr_repository_url = module.ecr.ecr_repository_url
}
