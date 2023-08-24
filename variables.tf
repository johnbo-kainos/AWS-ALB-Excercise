//AWS Configuration
variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "naming_prefix" {
  description = "Prefix used for naming of resources in AWS"
  default     = "academy-instructor"
}

//EC2 Configuration
variable "instance_type" {
  description = "EC2 intance type"
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 intances in each Availibilty Zone"
  default     = 2
}

//Networking vars
variable "vpc_cidr" {
  description = "CIDR IP Range of VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR IP range of the public subnet"
  default     = "10.0.0.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR IP range of the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR IP range of the public subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR IP range of the public subnet"
  default     = "10.0.4.0/24"
}

//Security Group vars
# variable "kainos_trusted_ips" {
#   type        = list(string)
#   description = "List of trusted Kainos IP addresses"
# }

//ALB vars


//ECS Fargate Vars

variable "enable_ecs" {
  type        = bool
  description = "Flag"
  default     = false

}

variable "capacity_providers" {
  type        = list(string)
  description = "List of capacity providers for ECS cluster"
  default     = ["FARGATE", "FARGATE_SPOT"]
}


