output "efs_id" {
  description = "The ID that identifies the file system (e.g. fs-ccfc0d65)."
  value       = aws_efs_file_system.this.id
}

output "efs_arn" {
  description = "The ARN for the EFS file system."
  value       = aws_efs_file_system.this.arn
}

output "efs_dns_name" {
  description = "The DNS name for the EFS file system."
  value       = aws_efs_file_system.this.dns_name
}

output "efs_mount_targets" {
  description = "The mount targets for the EFS file system."
  value       = aws_efs_mount_target.this
}

output "efs_access_point_id" {
  description = "The ID of the EFS access point."
  value       = aws_efs_access_point.this.id
}