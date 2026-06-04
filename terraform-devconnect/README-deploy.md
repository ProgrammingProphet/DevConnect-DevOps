# DevConnect EKS Provisioning with Terraform

This repository contains the Terraform code needed to provision an Amazon EKS cluster and its networking infrastructure for the DevConnect project. 

## Prerequisites
- **AWS CLI:** Installed and configured (`aws configure`) with credentials having administrator privileges.
- **Terraform:** Installed on your machine.
- **S3 Bucket & DynamoDB Table:** You must create an S3 bucket and a DynamoDB table for Terraform's remote backend state storage.

## 1. Install Terraform
If you are running on **Ubuntu WSL**, you can use the provided script:
```bash
chmod +x install_terraform.sh
./install_terraform.sh
```

## 2. Prepare Remote State Backend
Before running Terraform, you must create a backend to store your state file securely.
1. Create an S3 Bucket (e.g., `devconnect-terraform-state-bucket-replace-me`) in `ap-south-1`.
2. Create a DynamoDB Table (e.g., `devconnect-terraform-state-lock`) with `LockID` as the Partition Key (String).
3. **Update `backend.tf`:** Replace the dummy bucket name and DynamoDB table name with the ones you just created.

## 3. Deployment Steps

Navigate into the `terraform-devconnect` directory and run the following commands.

### Initialize the Terraform project
This command initializes the remote backend and downloads the required AWS provider and modules.
```bash
terraform init
```

### Plan the Infrastructure
Review the infrastructure changes that Terraform intends to make.
```bash
terraform plan
```

### Apply the Infrastructure
Provision the VPC, Security Groups, IAM Roles, and EKS Cluster.
```bash
terraform apply
```
*(Type `yes` when prompted to confirm.)*

## 4. Post-Deployment (Connect to the Cluster)

Once Terraform finishes successfully, it will output a command to configure your local `kubeconfig`. Run it:
```bash
aws eks update-kubeconfig --region ap-south-1 --name devconnect-cluster
```

You can verify the connection with:
```bash
kubectl get nodes
```

## 5. Next Steps
- Install **ArgoCD** into the cluster using the previously generated scripts in the `argocd/` folder.
- Follow the GitOps workflow by pushing your application manifests to your GitHub repository and registering it with ArgoCD.
