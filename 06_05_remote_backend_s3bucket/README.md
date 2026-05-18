# Terraform Remote Backend Setup on AWS (S3)

This Terraform project provisions the necessary AWS infrastructure to **enable remote state management** using **Amazon S3**.

> Remote backends allow teams to securely share and lock Terraform state files, a critical requirement for collaboration and consistency in DevOps workflows.

---

## Step-01: What This Project Does
- Creates an **S3 Bucket** to store Terraform state files.
- Supports parameterization using input variables for environment-specific deployments.

---

## Step-02: File Structure

| File              | Purpose                                                                 |
|-------------------|-------------------------------------------------------------------------|
| `c1-versions.tf`   | Specifies required Terraform version and AWS provider                  |
| `c2-variables.tf`  | Declares input variables like `bucket_name`, `dynamodb_table`, etc.    |
| `c3-s3bucket.tf`   | Creates the S3 bucket for remote backend            |
| `c4-outputs.tf`    | Exposes outputs such as the bucket name and table name                 |

---

## Step-03: Example Usage

```bash
# Initialize the project
terraform init

# Preview the resources to be created
terraform plan

# Apply the configuration
terraform apply
````

---

## Sample Backend Configuration (for other Terraform projects)

Once this backend is created, use the following block in your main projects to store state remotely:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket-name"
    key            = "env-name/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-lock-table-name"
    encrypt        = true
  }
}
```

> Replace `your-tfstate-bucket-name` and `your-lock-table-name` with actual output values from this project.

---

## Why Use Remote Backend?

* **Team Collaboration**: Prevent state conflicts when multiple people run Terraform.
* **State Locking**: Avoids race conditions using DynamoDB.
* **Durability**: S3 ensures highly available and persistent state storage.

---

## Next Step

After setting up the backend infrastructure, you can safely use it in your **main Terraform configurations** for provisioning VPCs, EKS clusters, etc.

---
# terraform-iac-aws
