THIS IS THE STRAPI APPLICATION EXPLANATION LOOM VIDEO LINK:
https://www.loom.com/share/e58246ba57f6441182491a8d0b2bc9ab


Automated Strapi Deployment on AWS using Terraform

This project automates the provisioning and deployment of a Strapi (Headless CMS) application on AWS. It uses Terraform for Infrastructure as Code (IaC) to set up the networking and compute resources, and a Bash User Data script to handle the OS-level configuration, dependency installation, and application startup.

<img width="1920" height="1200" alt="Screenshot 2025-12-02 170838" src="https://github.com/user-attachments/assets/a068dba5-bf55-4bee-bb04-79ccdc2f168a" />

first i run the strapi application in my local

<img width="1920" height="1200" alt="Screenshot 2025-12-02 171035" src="https://github.com/user-attachments/assets/85af2148-1e0b-4ef4-a370-bc76a4f799a7" />

see i successfully run the application

<img width="1920" height="1200" alt="Screenshot 2025-12-02 171120" src="https://github.com/user-attachments/assets/a790112b-fd16-4f88-a4f1-c605721efd6f" />

<img width="1920" height="1200" alt="Screenshot 2025-12-02 180315" src="https://github.com/user-attachments/assets/3ea6c7e5-ca53-4df6-a0f7-e7aab32b8539" />

applied the terraform code successfully

<img width="1920" height="1200" alt="Screenshot 2025-12-02 193511" src="https://github.com/user-attachments/assets/9336f3ce-0f18-41aa-b407-bc500574f3ee" />

Successfully i got the strapi application through running of tearrform code



🏗 Architecture

The Terraform configuration provisions the following resources in the us-east-1 region:

VPC: A custom Virtual Private Cloud to isolate resources.

Public Subnet: Hosts the Strapi server, allowing internet access.

Internet Gateway & Route Table: Enables connectivity to the outside world.

Security Group: firewall rules allowing:

SSH (22): For administrative access.

HTTP (1337): The default Strapi application port.

HTTP (80): For future web server configuration.

EC2 Instance: Ubuntu 22.04 LTS server (configurable size) that hosts the application.

Swap Memory: Automatically configured (2GB) to support Strapi build processes on memory-constrained instances.
✅ Prerequisites

Before deploying, ensure you have:

AWS Account: Access to an AWS account with permissions to create EC2, VPC, and Key Pairs.

Terraform: Installed on your local machine (Download here).

AWS CLI: Configured with your credentials (aws configure).

🚀 Deployment Guide

1. Clone the Repository

git clone [https://github.com/sivabhargav783/strapi-project.git](https://github.com/sivabhargav783/strapi-project.git)
cd strapi-project


2. Configure Instance Type

Open variables.tf to select your desired instance size.

Default: m7i-flex.large (Recommended for speed).

3. Initialize & Apply Terraform

Initialize the project and download providers:

terraform init


Review and apply the plan:

terraform apply


Type yes when prompted.

4. Wait for Provisioning

Once Terraform finishes, the AWS infrastructure is ready, but the server setup continues in the background.

Time estimate: 5-10 minutes (depending on instance type).
you are successful! Open your browser to http://<YOUR_IP>:1337/admin.
