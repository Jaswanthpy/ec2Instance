resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "spot_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name != "" ? var.key_name : null
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt upgrade -y
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    sudo apt install nodejs -y
  EOF

  # Spot Instance Request
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price          = 0.01 # Set your max price or leave commented to use on-demand price
      spot_instance_type = "one-time"
    }
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = var.tags
}
