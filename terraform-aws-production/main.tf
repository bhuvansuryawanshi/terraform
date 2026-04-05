module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "sg" {
  source       = "./modules/sg"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  sg_id             = module.sg.sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
}


module "asg" {
  source             = "./modules/asg"
  project_name       = var.project_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  sg_id              = module.sg.sg_id
  tg_arn             = module.alb.tg_arn
  private_subnet_ids = module.vpc.private_subnet_ids
}


module "cf" {
  source       = "./modules/cf"
  alb_dns_name = module.alb.alb_dns_name
  project_name = var.project_name

}