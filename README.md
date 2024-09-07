# Terraform Configuration for AWS 3-Tier Application Infrastructure
 
## Overview
This Terraform configuration defines an AWS infrastructure setup, including VPC, subnets, security groups, and various resources for a 3-tier architecture. The setup consists of public and private subnets across multiple availability zones, with dedicated layers for web, application, and database components. It also includes a bastion host for SSH access.
 
## Requirements
- Terraform v0.13+
- AWS CLI installed and configured
- An AWS account with the appropriate IAM permissions
 
## Providers
- **AWS**: This configuration uses the AWS provider with version 4.0.0. Ensure this is installed before running the configuration.
 
## Variables
- `aws_region`: The AWS region where the infrastructure will be provisioned.
- `vpc_cidr_block`: The CIDR block for the VPC.
- `public_subnet_cidr_blocks`: A list of CIDR blocks for public subnets.
- `private_subnet_web_cidr_blocks`: A list of CIDR blocks for private web subnets.
- `private_subnet_app_cidr_blocks`: A list of CIDR blocks for private application subnets.
- `private_subnet_db_cidr_blocks`: A list of CIDR blocks for private database subnets.
- `subnet_count`: A map defining the count of public and private subnets.
- `my_ip`: The IP address from which SSH access will be allowed.
- `db_username` and `db_password`: Credentials for the RDS database.
- `settings`: Nested settings for configuring the database, web, and bastion instances.
 
## Resources
 
### VPC and Networking
- **aws_vpc**: Defines the VPC for the infrastructure.
- **aws_subnet**: Creates public and private subnets across availability zones.
- **aws_internet_gateway**: Provides internet access to the public subnets.
- **aws_nat_gateway**: Allows private subnets to access the internet through a NAT gateway.
- **aws_route_table & aws_route_table_association**: Defines and associates route tables for public and private subnets.
 
### Compute Instances
- **aws_instance (ep_web, ep_app_dev, ep_bastion)**: Creates instances for the web, application, and bastion layers. AMIs are automatically fetched based on the RHEL 9.3 image.
- **aws_eip**: Elastic IPs for the bastion host and NAT gateway.
  
### Database
- **aws_db_instance**: Provisions an RDS instance for PostgreSQL with security group rules allowing access from the application layer.
- **aws_db_subnet_group**: Specifies the subnets for the database instances.
 
### Security Groups
- **ep_web_sg**: Security group for web servers, allowing HTTPS, HTTP, and SSH from the bastion host.
- **ep_app_sg**: Security group for application servers, allowing web traffic and SSH from the bastion host.
- **ep_bastion_sg**: Security group for the bastion host, allowing SSH from a specific IP.
- **ep_db_sg**: Security group for the database, restricting access to only the application security group.
 
### AMI
- **aws_ami (rhel_9-3)**: The configuration fetches the latest Red Hat Enterprise Linux 9.3 AMI.
 
## User Data Scripts
- `app_config.sh`: Custom configuration for application instances.
- `web_config.sh`: Custom configuration for web server instances.
- `bastion_config.sh`: Custom configuration for the bastion host.
 

## Secrets and Sensitive Variables
 
This Terraform configuration relies on sensitive variables, such as database credentials and SSH keys, which should not be hard-coded in the configuration files or included in version control. These sensitive variables should be stored in a separate `secrets.tfvars` file.
 
### Example `secrets.tfvars` File
```bash
db_username = "your_database_username"
db_password = "your_database_password"
my_ip       = "your_ip_address"
```


## How to Use
0. ***Create web-kp***: 
- Create Private/Public key Pair named "web-kp" that will be used as key in the instances. 
- Note! For security reasons the key is not included in the key configuration and should be created manually. 
 
1. **Install and Configure Terraform**:
- Install Terraform from [terraform.io](https://www.terraform.io/downloads.html).
   - Set up your AWS CLI with the required credentials and region.
 
2. **Initialize Terraform**:
   - Run `terraform init` to initialize the working directory and download the necessary providers.
 
3. **Plan the Infrastructure**:
   - Run `terraform plan` to review the resources that will be created and ensure the configuration is correct.
 
4. **Apply the Configuration**:
   - Run `terraform apply` to provision the resources in your AWS account.
 
5. **Access the Bastion Host**:
   - Use the Elastic IP (EIP) created for the bastion host to SSH into the instance.
 
## Clean Up
To destroy the infrastructure and avoid charges, run:
```bash
terraform destroy
```

## Setup Scripts Overview

This project includes several Bash scripts to configure the environment for the web app, backend server, and bastion host with JFrog Artifactory. Below is a summary of each script's purpose.

### Web App Setup Script

The web app setup script performs the following tasks:
- Installs Node.js and npm.
- Installs development tools and additional prerequisites for React development.
- Optionally updates npm to the latest version.

This script should be run on the EC2 instance that hosts the front-end of the application.

### Backend Setup Script

The backend setup script is responsible for:
- Installing Java OpenJDK 17.
- Downloading and setting up Apache Maven.
- Configuring environment variables for Java and Maven.

This script should be executed on the EC2 instance designated for backend services.

### Bastion Host and JFrog Artifactory Setup Script

The bastion host and Artifactory setup script does the following:
- Installs wget and updates the system.
- Downloads and extracts JFrog Artifactory.
- Starts the JFrog Artifactory service on the server.

This script should be run on the bastion host EC2 instance where Artifactory is installed.

