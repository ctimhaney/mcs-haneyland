terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  availability_zones = ["us-east-2a"]
  prefix             = "mcs-haneyland"
}

# TODO More sophisticated stiching of modules from other repos. Remote state! OR private CD engine that maintains the files.
data "aws_iam_instance_profile" "ssm" {
  name = "cth_persist_ssm_instance_profile"
}

module "mcs_vpc" {
  # source = "github.com/ctimhaney/terraform-modules//terraform-aws-vpc"
  source = "../../terraform-modules/terraform-aws-vpc/"

  aws_region         = var.aws_region
  prefix             = var.prefix
  vpc_cidr           = "10.10.0.0/16"
  internal_subnets   = []
  external_subnets   = ["10.10.1.0/24"]
  availability_zones = local.availability_zones
  external_nacl_ingress = [
    {
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
      from_port  = "1024"
      to_port    = "65535"
    }
  ]
  external_nacl_egress = [
    {
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
      from_port  = "0"
      to_port    = "65535"
    }
  ]
}

module "mcs_compute" {
  # source = "github.com/ctimhaney/terraform-modules//terraform-aws-mcs"
  source = "../../terraform-modules/terraform-aws-mcs/"

  aws_region                = var.aws_region
  prefix                    = var.prefix
  vpc_id                    = module.mcs_vpc.vpc_id
  ami_id                    = "ami-0d481e8f85983c5b0"
  ebs_volume_size           = 50
  instance_type             = "t2.large"
  key_name                  = var.key_name
  vpc_asg_subnets           = module.mcs_vpc.external_subnets
  vpc_lb_subnets            = module.mcs_vpc.external_subnets
  iam_instance_profile_name = data.aws_iam_instance_profile.ssm.name
  server_version            = "1.16.5"
}
