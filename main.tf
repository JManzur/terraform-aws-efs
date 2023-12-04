resource "aws_kms_key" "efs" {
  description             = "${var.name_prefix}-efs-key"
  deletion_window_in_days = 15
  multi_region            = false
  enable_key_rotation     = true

  tags = { Name = "${var.name_prefix}-efs-key" }
}

resource "aws_kms_alias" "efs" {
  name          = "alias/${var.name_prefix}-efs-key"
  target_key_id = aws_kms_key.efs.key_id
}

resource "aws_efs_file_system" "this" {
  creation_token = "${var.name_prefix}-efs"

  encrypted                       = true
  kms_key_id                      = aws_kms_key.efs.arn
  performance_mode                = var.efs_settings[0].performance_mode
  throughput_mode                 = var.efs_settings[0].throughput_mode
  provisioned_throughput_in_mibps = try(var.efs_settings[0].provisioned_throughput_in_mibps, null)

  dynamic "lifecycle_policy" {
    for_each = var.efs_lifecycle_policy[0].enable ? [1] : []
    content {
      transition_to_ia                    = var.efs_lifecycle_policy[0].to_infrequent_access
      transition_to_primary_storage_class = var.efs_lifecycle_policy[0].to_primary_storage
    }
  }

  tags = { Name = "${var.name_prefix}-efs" }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }

  tags = { Name = "${var.name_prefix}-efs-ap" }
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "efs" {
  name        = "${var.name_prefix}-efs-sg"
  description = "EFS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "NFS"
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = [local.vpc_cidr]
  }

  egress {
    description = "All"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-efs-sg" }
}

resource "aws_efs_mount_target" "this" {
  count = length(var.private_subnets)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = element(var.private_subnets, count.index)
  security_groups = [aws_security_group.efs.id]
}
