
variable "ami_id" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "user_data" {}
variable "env" {}
variable "group" {}

resource "aws_launch_template" "lt" {
  name = "${var.group}-${var.env}-lt"
  image_id = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(var.user_data)
}

output "launch_template_id" { value = aws_launch_template.lt.id }
