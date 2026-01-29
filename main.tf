# Data source for Ubuntu 24.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "spot_instance" {
  ami           = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? var.key_name : null

  # Spot Instance Request
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price          = 0.0040 # Set your max price or leave commented to use on-demand price
      spot_instance_type = "one-time"
    }
  }

  tags = var.tags
}
