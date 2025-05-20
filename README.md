# 🌐 S3 Static Website Hosting with Terraform + Remote State

This Terraform project sets up a fully functional static website hosted on AWS S3 and configures a remote backend for managing state files securely in another S3 bucket.

---

## 🚀 Features

- ✅ Creates a public S3 bucket to host your static website (HTML, CSS, JS).
- ✅ Enables static website hosting on S3.
- ✅ Uploads all website files from a local directory.
- ✅ Adds a public-read bucket policy.
- ✅ Stores Terraform state remotely in a secure S3 backend.

---

## 🛠️ Project Structure

```bash
.
├── main.tf                # Infrastructure configuration
├── providers.tf           # AWS provider with credentials
├── variables.tf           # Input variables
├── terraform.tfvars       # Actual values for variables
└── grandcoffee-master/    # Your static website files (HTML, CSS, JS)

🔐 Backend Configuration
  The project uses this block to store state remotely:

terraform {
  backend "s3" {
    bucket  = "terraform-tfstate-files-backend"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
🧪 How to Deploy
# 1. Initialize Terraform
terraform init

# 2. Validate the configuration
terraform validate

# 3. Apply changes
terraform apply

📦 Inputs via terraform.tfvars
bucketname  = "your-static-site-bucket"
access_key  = "YOUR_ACCESS_KEY"
secret_key  = "YOUR_SECRET_KEY"

🔐 Note
Your terraform.tfstate will be stored in the remote backend (another S3 bucket).

Make sure your AWS credentials are valid in terraform.tfvars.

🤝 Author
Made with ❤️ by [Mohammed Faisal Iqbal]

---


