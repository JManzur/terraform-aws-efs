#######################################
# Required variables:
#######################################

variable "name_prefix" {
  description = "[REQUIRED] Used to name and tag resources."
  type        = string
}

variable "vpc_id" {
  description = "[REQUIRED] The VPC ID where the EFS mount target will be created."
  type        = string
}

variable "private_subnets" {
  description = "[REQUIRED] A required list of private subnets where the EFS mount target will be created."
  type        = list(string)
}

#######################################
# Optional variables:
#######################################

variable "efs_lifecycle_policy" {
  description = "[OPTIONAL] Configures the EFS lifecycle policy to transition files to the Infrequent Access storage class"
  type = list(object({
    enable               = bool
    to_infrequent_access = optional(string)
    to_primary_storage   = optional(string)
  }))

  default = [{
    enable               = false
    to_infrequent_access = "AFTER_90_DAYS"
    to_primary_storage   = "AFTER_1_ACCESS"
  }]

  validation {
    condition = (
      var.efs_lifecycle_policy[0].to_infrequent_access == "AFTER_7_DAYS" ||
      var.efs_lifecycle_policy[0].to_infrequent_access == "AFTER_14_DAYS" ||
      var.efs_lifecycle_policy[0].to_infrequent_access == "AFTER_30_DAYS" ||
      var.efs_lifecycle_policy[0].to_infrequent_access == "AFTER_60_DAYS" ||
      var.efs_lifecycle_policy[0].to_infrequent_access == "AFTER_90_DAYS"
    )
    error_message = "Invalid EFS lifecycle policy: to_infrequent_access must be one of AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS."
  }

  validation {
    condition     = var.efs_lifecycle_policy[0].to_primary_storage == "AFTER_1_ACCESS"
    error_message = "Invalid EFS lifecycle policy: to_primary_storage must be AFTER_1_ACCESS."
  }
}

variable "efs_settings" {
  description = "[OPTIONAL] Configures the EFS throughput mode and performance mode."
  type = list(object({
    performance_mode                = string
    throughput_mode                 = string
    provisioned_throughput_in_mibps = optional(number)
  }))

  validation {
    condition = (
      var.efs_settings[0].performance_mode == "generalPurpose" ||
      var.efs_settings[0].performance_mode == "maxIO"
    )
    error_message = "Invalid EFS performance_mode: performance_mode must be one of generalPurpose or maxIO."
  }

  validation {
    condition = (
      var.efs_settings[0].throughput_mode == "bursting" ||
      var.efs_settings[0].throughput_mode == "provisioned" ||
      var.efs_settings[0].throughput_mode == "elastic"
    )
    error_message = "Invalid EFS throughput_mode: throughput_mode must be one of bursting or provisioned."
  }

  validation {
    condition = (
      var.efs_settings[0].throughput_mode != "provisioned" ||
      (var.efs_settings[0].throughput_mode == "provisioned" &&
        var.efs_settings[0].provisioned_throughput_in_mibps != null &&
        var.efs_settings[0].provisioned_throughput_in_mibps >= 1 &&
      var.efs_settings[0].provisioned_throughput_in_mibps <= 1024)
    )
    error_message = "Invalid EFS provisioned_throughput_in_mibps: provisioned_throughput_in_mibps must be between 1 and 1024."
  }
}