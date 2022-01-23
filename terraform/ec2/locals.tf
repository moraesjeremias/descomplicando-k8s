locals {
  app_name = "k8s-lab"
  region   = "us-east-1"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

locals {
  ebs_block = {
    root_block_device = [
      {
        encrypted   = false
        volume_type = "gp2"
        volume_size = 8
      }
    ]
  }
}

locals {
  multiple_instances = {
    one_main = {
      availability_zone = element(module.k8s_vpc_lab.azs, 0)
      subnet_id         = element(module.k8s_vpc_lab.public_subnets, 0)
      tags = {
        Environment = "dev"
        k8sRole     = "Main"
      }
    }
    two_worker = {
      availability_zone = element(module.k8s_vpc_lab.azs, 1)
      subnet_id         = element(module.k8s_vpc_lab.public_subnets, 1)
      tags = {
        Environment = "dev"
        k8sRole     = "Worker"
      }
    }
    three_worker = {
      availability_zone = element(module.k8s_vpc_lab.azs, 2)
      subnet_id         = element(module.k8s_vpc_lab.public_subnets, 2)
      tags = {
        Environment = "dev"
        k8sRole     = "Worker"
      }
    }
  }
}
