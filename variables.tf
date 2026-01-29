variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-2"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance."
  type        = string
  default     = "ami-02774d409be696d81"
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use"
  type        = string
  default     = "privateAWS" # Optional, leave empty if no key is needed
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Name = "ClawdBot"
  }
}
