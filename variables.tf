variable "aws_region" {
  default = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_count" {
  description = "Number of subnets"
  type        = map(number)
  default = {
    public  = 2,
    private = 2
  }
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
  default = {
    "database" = {
      allocated_storage   = 10
      engine              = "postgres"
      instance_class      = "db.t3.micro"
      db_name             = "ep_postgres_db_dev"
      skip_final_snapshot = true
    },
    "web_app" = {
      count         = 1
      instance_type = "t2.micro"
    },
    "app_app" = {
      count         = 1
      instance_type = "t2.micro"
    },
     "bastion" = {
      count         = 1
      instance_type = "t2.small"
    }
  }
}

variable "public_subnet_cidr_blocks" {
  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

variable "private_subnet_web_cidr_blocks" {
  description = "Available CIDR blocks for private subnets for web layer"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
  ]
}

variable "private_subnet_app_cidr_blocks" {
  description = "Available CIDR blocks for private subnets for app layer"
  type        = list(string)
  default = [
    "10.0.103.0/24",
    "10.0.104.0/24",
  ]
}

variable "private_subnet_db_cidr_blocks" {
  description = "Available CIDR blocks for private subnets for db layer"
  type        = list(string)
  default = [
    "10.0.105.0/24",
    "10.0.106.0/24",
  ]
}

variable "db_username" {
  description = "Database master user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master user password"
  type        = string
  sensitive   = true
}

variable "my_ip" {
  description = "Public IP of the user creating the configuration"
  type        = string
  sensitive   = true
}