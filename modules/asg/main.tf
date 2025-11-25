
variable "launch_template_id" {}
variable "subnet_ids" {}
variable "target_group_arn" {}
variable "min_size" {}
variable "max_size" {}
variable "env" {}
variable "group" {}

resource "aws_autoscaling_group" "asg" {
  name               = "${var.group}-${var.env}-asg"
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.min_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}

output "asg_name" { value = aws_autoscaling_group.asg.name }
