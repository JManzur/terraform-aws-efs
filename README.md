# EFS Terraform Module

This module creates an EFS filesystem and mount targets.

## Usage

```bash
module "efs" {
  source = "git::https://github.com/JManzur/terraform-aws-efs.git?ref=v1.0.0"

  name_prefix     = "Demo"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet
  efs_settings = [{
    performance_mode                = "generalPurpose"
    throughput_mode                 = "bursting"
    provisioned_throughput_in_mibps = 0
  }]
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->