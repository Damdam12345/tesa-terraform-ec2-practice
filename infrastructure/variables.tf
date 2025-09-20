variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-3"
}
# variables.tf
variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-00ffe463659a905fd"
}
variable "member_name" {
  description = "Your name for tagging resources"
  type        = string
  default     = "Damilare"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "tesa-damilare-key"
}