# Purpose: Call the network module and pass necessary variables

module "network" {
  source            = "../../modules/network"
  vpc_id            = var.vpc_id
  vpc_cidr_block    = var.vpc_cidr_block
  environment       = var.environment
  azs               = var.azs
  owner_tag         = var.owner_tag
}
