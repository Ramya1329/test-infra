# Purpose: Call the network module and pass necessary variables

module "network" {
  source            = "../../modules/network"           
  environment       = var.environment                   
  vpc_cidr_block    = var.vpc_cidr_block                
  azs               = var.azs                           
}
