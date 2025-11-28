
provider "aws" { region = "us-east-1" }

variable "ami" {
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  default = "t3.micro"
}


module "network" {
  source = "../../modules/network"
  vpc_cidr = "10.100.0.0/16"
  env = "dev"
  group = "group-one"
  azs = ["us-east-1a","us-east-1b","us-east-1c"]
}

module "launch_template" {
  source = "../../modules/launch_template"

  ami_id               = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = "LabInstanceProfile"

  user_data = templatefile("${path.module}/user_data.tpl", {
    images_bucket = "group-one-${var.env}-images"
    env_upper     = upper(var.env)
  })

  env   = var.env
  group = "group-one"
}


module "alb" {
  source = "../../modules/alb"
  subnet_ids = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
  env = "dev"
  group = "group-one"
}

module "asg" {
  source = "../../modules/asg"
  launch_template_id = module.launch_template.launch_template_id
  subnet_ids = module.network.public_subnet_ids
  target_group_arn = module.alb.target_group_arn
  min_size = 2
  max_size = 4
  env = "dev"
  group = "group-one"
}

module "scaling" {
  source = "../../modules/scaling"
  asg_name = module.asg.asg_name
}

output "alb_dns" {
  value = module.alb.alb_dns
}
