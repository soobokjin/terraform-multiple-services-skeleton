locals {
  availability_zone_suffix = split("-", var.availability_zone)[length(split("-", var.availability_zone)) - 1]
  name                     = "${var.stage}-${var.project_name}-${var.service_name}-ec2-${local.availability_zone_suffix}"
  tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}

# TODO: ami 없는 케이스에 대한 처리
data "aws_ami" "this" {
  most_recent = true
  owners      = var.owners

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}


resource "aws_iam_instance_profile" "this" {
  name = "${local.name}-i-profile"
  role = "CloudWatchAgentServerRole"
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = var.instance_type

  associate_public_ip_address = var.associate_public_ip_address
  availability_zone           = var.availability_zone
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_groups
  iam_instance_profile        = aws_iam_instance_profile.this.name



  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      volume_size = ebs_block_device.value.volume_size
      device_name = "/dev/sda1"
      volume_type = "gp2"
    }
  }

  tags = local.tags
}
