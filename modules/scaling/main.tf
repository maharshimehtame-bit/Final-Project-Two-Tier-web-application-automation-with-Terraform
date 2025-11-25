
variable "asg_name" {}

resource "aws_autoscaling_policy" "scale_out" {
  name = "${var.asg_name}-scale-out"
  autoscaling_group_name = var.asg_name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
}

resource "aws_autoscaling_policy" "scale_in" {
  name = "${var.asg_name}-scale-in"
  autoscaling_group_name = var.asg_name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
}

output "scale_out_policy" { value = aws_autoscaling_policy.scale_out.arn }
output "scale_in_policy" { value = aws_autoscaling_policy.scale_in.arn }
