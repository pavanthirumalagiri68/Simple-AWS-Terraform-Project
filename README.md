# Terraform AWS VPC Setup

This Terraform configuration creates an Amazon Web Services (AWS) Virtual Private Cloud (VPC) along with public and private subnets, route table, internet gateway, security groups, and an EC2 instance running an Apache web server.

## Prerequisites

- AWS CLI installed and configured with appropriate credentials.
- Terraform installed on your local machine.

## Configuration

The configuration is defined in `main.tf`. Here's an overview of the steps:

1. **Provider Setup**: Specifies the AWS provider with the configured profile and region.

2. **VPC Creation**: Creates a VPC with the CIDR block `10.0.0.0/16`.

3. **Public Subnet Creation**: Creates a public subnet with CIDR `10.0.1.0/24` in availability zone `ap-south-1a`. Enables automatic public IP assignment.

4. **Private Subnet Creation**: Creates a private subnet with CIDR `10.0.2.0/24` in availability zone `ap-south-1a`.

5. **Internet Gateway**: Creates an Internet Gateway and attaches it to the VPC for public internet access.

6. **Public Route Table**: Creates a route table for the public subnet and associates it with the Internet Gateway. Enables access to the public internet.

7. **Security Group**: Creates a security group named `ssh_access`. Allows incoming SSH (port 22) and HTTP (port 80) traffic, and allows all outbound traffic.

8. **EC2 Instance**: Launches an EC2 instance using the specified AMI. It's placed in the public subnet and associated with the security group. The user data script installs Apache and creates a basic welcome page.

## Usage

1. Clone this repository to your local machine.
2. Navigate to the directory containing the `.tf` files.
3. Run `terraform init` to initialize the configuration.
4. Run `terraform apply` to create the resources.
5. After applying, Terraform will output information about the created resources, including the EC2 instance's public IP.

## Clean Up

1. To remove all created resources, run `terraform destroy`.


