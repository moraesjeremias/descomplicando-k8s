module "k8s_vpc_lab" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.3"

  name = local.app_name
  cidr = "10.0.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  
  create_database_subnet_group     = true
  enable_nat_gateway               = true
  single_nat_gateway               = true

  tags = local.tags
}

module "k8s_sg_lab" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = local.app_name
  description = "Security group for K8s lab EC2 instance"
  vpc_id      = module.k8s_vpc_lab.vpc_id

  ingress_cidr_blocks = var.ip_allowlist
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  egress_rules        = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]

  tags = local.tags
}

module "k8s_ec2_lab" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "3.4.0"
  for_each = local.multiple_instances
  name     = "k8s_spot_${each.key}"

  create_spot_instance = true
  spot_price           = "0.70"
  spot_type            = "persistent"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.k8s_sg_lab.security_group_id]

  enable_volume_tags = false
  root_block_device  = local.ebs_block.root_block_device
  key_name           = aws_key_pair.k8s_lab_key_pair.key_name
  tags = each.value.tags
}
