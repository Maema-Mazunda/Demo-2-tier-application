# 🏗️ Demo-2-Tier-Application
### Highly Available & Scalable 2-Tier Architecture on AWS using Terraform Custom Modules

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![IaC](https://img.shields.io/badge/IaC-Infrastructure_as_Code-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

---

## 📌 Project Overview

This project provisions a **production-grade, highly available 2-tier architecture** on AWS using **Terraform custom modules**. The infrastructure is fully automated, scalable on demand, and follows cloud engineering best practices — including remote state management, state locking, and modular reusable code.

> Built to demonstrate real-world cloud infrastructure skills: from network design and compute scaling, to database resilience, CDN distribution, and observability.

---

## 🧱 Architecture Diagram

```
                          ┌─────────────────────────────────────────────────┐
                          │               AWS Cloud (Multi-AZ)              │
                          │                                                  │
    Users ──► Route 53 ──► CloudFront ──► ALB                              │
                          │               │                                  │
                          │    ┌──────────▼──────────┐                      │
                          │    │   Auto Scaling Group │                      │
                          │    │  ┌────────┐ ┌──────┐│                      │
                          │    │  │ EC2 AZ1│ │EC2 AZ2││                     │
                          │    │  └────────┘ └──────┘│                      │
                          │    └──────────┬──────────┘                      │
                          │               │                                  │
                          │    ┌──────────▼──────────┐                      │
                          │    │    Amazon RDS         │                      │
                          │    │  (Multi-AZ MySQL)    │                      │
                          │    └─────────────────────┘                      │
                          │                                                  │
                          │    S3 (tfstate) + DynamoDB (state lock)          │
                          └─────────────────────────────────────────────────┘
```

---

## ☁️ AWS Services Used

| Service | Purpose |
|---|---|
| **Amazon Certificate Manager (ACM)** | SSL/TLS certificate provisioning and management |
| **Amazon Route 53** | DNS routing and domain management |
| **Amazon CloudFront** | CDN for low-latency global content delivery |
| **Amazon EC2** | Web/application server instances |
| **Auto Scaling Group** | Elastic scaling based on CPU demand |
| **Amazon VPC** | Isolated private network with public/private subnets |
| **Amazon RDS (MySQL)** | Managed relational database with Multi-AZ failover |
| **Amazon DynamoDB** | Terraform remote state locking |
| **Amazon S3** | Remote backend for Terraform state file with versioning |
| **Amazon CloudWatch** | CPU alarms to trigger scale-out/scale-in events |

---

## 🧠 Key Concepts Demonstrated

- ✅ **Terraform Custom Modules** — Reusable, composable infrastructure components
- ✅ **Remote Backend** — State stored in S3 with versioning enabled
- ✅ **State File Locking** — DynamoDB table prevents concurrent state corruption
- ✅ **Input & Output Variables** — Clean module interfaces for flexibility and reuse
- ✅ **High Availability** — Multi-AZ deployment across VPC subnets
- ✅ **Auto Scaling** — CloudWatch alarms drive dynamic EC2 scaling policies
- ✅ **SSL Termination** — ACM certificate attached to CloudFront distribution
- ✅ **Terraform Best Practices** — Consistent naming, variable abstraction, modular structure

---

## 📁 Project Structure

```
Demo-2-tier-application/
├── modules/
│   ├── vpc/               # VPC, subnets, IGW, route tables
│   ├── ec2/               # Launch template, key pair, user data
│   ├── asg/               # Auto Scaling Group + CloudWatch alarms
│   ├── alb/               # Application Load Balancer + target groups
│   ├── rds/               # RDS MySQL Multi-AZ + subnet group
│   ├── cloudfront/        # CloudFront distribution + ACM cert
│   ├── route53/           # DNS records and hosted zone
│   └── s3-dynamodb/       # Remote backend + state locking
├── main.tf                # Root module — wires all modules together
├── variables.tf           # Input variable declarations
├── outputs.tf             # Output values (ALB DNS, RDS endpoint, etc.)
├── backend.tf             # S3 + DynamoDB remote backend config
├── terraform.tfvars       # Variable values (gitignored for secrets)
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.5+
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate IAM permissions
- An existing Route 53 hosted zone and registered domain (for ACM + CloudFront)

### 1. Clone the Repository

```bash
git clone https://github.com/Maema-Mazunda/Demo-2-tier-application.git
cd Demo-2-tier-application
```

### 2. Configure Backend (S3 + DynamoDB)

Create the S3 bucket and DynamoDB table for remote state before initialising:

```bash
# Create S3 bucket for state
aws s3api create-bucket --bucket <your-tfstate-bucket> --region <your-region>

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket <your-tfstate-bucket> \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### 3. Update Variables

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 4. Initialise and Deploy

```bash
terraform init      # Initialise providers and remote backend
terraform validate  # Validate configuration syntax
terraform plan      # Preview infrastructure changes
terraform apply     # Provision infrastructure
```

### 5. Destroy Resources (when done)

```bash
terraform destroy
```

---

## ⚙️ Auto Scaling Behaviour

CloudWatch alarms monitor EC2 CPU utilisation and trigger scaling policies:

| Condition | Action |
|---|---|
| CPU > 70% for 2 minutes | Scale **OUT** — add EC2 instance |
| CPU < 30% for 5 minutes | Scale **IN** — remove EC2 instance |

---

## 🔒 Security Highlights

- EC2 instances deployed in **private subnets** — no direct internet exposure
- RDS in **isolated private subnet group** — only reachable from app tier
- Traffic flow: `Users → CloudFront → ALB → EC2 → RDS`
- Security groups enforce least-privilege access between each tier
- HTTPS enforced via ACM + CloudFront — HTTP redirected to HTTPS

---

## 📊 What I Learned

This project deepened my hands-on understanding of:

- Designing modular, reusable Terraform code at scale
- Managing remote state safely in a team/CI environment
- Architecting for fault tolerance using Multi-AZ and ASGs
- Integrating observability (CloudWatch) into the infrastructure lifecycle
- Applying AWS networking fundamentals: VPCs, subnets, NACLs, security groups

---

## 👤 Author

**Maema Mazunda**
Solutions Architect | AWS Cloud Practitioner | Aspiring SAA-C03

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/maema-mazunda)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/Maema-Mazunda)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE). 