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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.29.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_kms_alias.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_lifecycle_policy"></a> [efs\_lifecycle\_policy](#input\_efs\_lifecycle\_policy) | [OPTIONAL] Configures the EFS lifecycle policy to transition files to the Infrequent Access storage class | <pre>list(object({<br>    enable               = bool<br>    to_infrequent_access = optional(string)<br>    to_primary_storage   = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "enable": false,<br>    "to_infrequent_access": "AFTER_90_DAYS",<br>    "to_primary_storage": "AFTER_1_ACCESS"<br>  }<br>]</pre> | no |
| <a name="input_efs_settings"></a> [efs\_settings](#input\_efs\_settings) | [OPTIONAL] Configures the EFS throughput mode and performance mode. | <pre>list(object({<br>    performance_mode                = string<br>    throughput_mode                 = string<br>    provisioned_throughput_in_mibps = optional(number)<br>  }))</pre> | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | [REQUIRED] Used to name and tag resources. | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | [REQUIRED] A required list of private subnets where the EFS mount target will be created. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | [REQUIRED] The VPC ID where the EFS mount target will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_access_point_id"></a> [efs\_access\_point\_id](#output\_efs\_access\_point\_id) | The ID of the EFS access point. |
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | The ARN for the EFS file system. |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | The DNS name for the EFS file system. |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | The ID that identifies the file system (e.g. fs-ccfc0d65). |
| <a name="output_efs_mount_targets"></a> [efs\_mount\_targets](#output\_efs\_mount\_targets) | The mount targets for the EFS file system. |

## Author:

- [@JManzur](https://jmanzur.com)
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->