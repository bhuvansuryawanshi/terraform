module "vpc" {
  source          = "./modules/vpc"
  project_name    = var.project_name
  vpc_cidr_block  = var.vpc_cidr_block
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_2b_cidr = var.pub_sub_2b_cidr
  pri_sub_3a_cidr = var.pri_sub_3a_cidr
  pri_sub_4b_cidr = var.pri_sub_4b_cidr
  pri_sub_5a_cidr = var.pri_sub_5a_cidr
  pri_sub_6b_cidr = var.pri_sub_6b_cidr
  aws_region      = var.aws_region
}


module "nat" {
  source        = "./modules/nat"
  vpc_id        = module.vpc.vpc_id
  pub_sub_1a_id = module.vpc.pub_sub_1a
  pub_sub_2b_id = module.vpc.pub_sub_2b
  pri_sub_3a_id = module.vpc.pri_sub_3a
  pri_sub_4b_id = module.vpc.pri_sub_4b
  pri_sub_5a_id = module.vpc.pri_sub_5a
  pri_sub_6b_id = module.vpc.pri_sub_6b
  igw_id        = module.vpc.aws_internet_gateway
}


module "security_group" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id

}

# creating Key for instances
module "key" {
  source = "./modules/key"
}


module "alb" {
  source        = "./modules/alb"
  project_name  = module.vpc.project_name
  alb_sg_id     = module.security_group.alb_sg_id
  vpc_id        = module.vpc.vpc_id
  pub_sub_1a_id = module.vpc.pub_sub_1a
  pub_sub_2b_id = module.vpc.pub_sub_2b
}


module "asg" {
  source        = "./modules/asg"
  project_name  = module.vpc.project_name
  key_name      = module.key.key_name
  client_sg_id  = module.security_group.client_sg_id
  pri_sub_3a_id = module.vpc.pri_sub_3a
  pri_sub_4b_id = module.vpc.pri_sub_4b
  tg_arn        = module.alb.tg_arn
}