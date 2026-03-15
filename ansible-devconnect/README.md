# DevConnect Ansible Configuration

This directory contains the Ansible playbooks and roles required to bootstrap the DevConnect EKS cluster and configure ArgoCD for GitOps.

## Workflow Explanation

The architecture is built on the GitOps methodology. 
1. **GitHub Actions (CI):** Builds application code changes, creates Docker images, pushes them to Docker Hub, and updates the manifests repository with the new image tag.
2. **ArgoCD (CD):** Continuously monitors the Kubernetes manifests repo. Once it detects a change made by the CI pipeline, it automatically pulls and deploys those changes to the EKS Cluster.

These Ansible playbooks set up the control node environment and bootstrap the cluster for ArgoCD.

## Prerequisites

- An active **AWS EKS Cluster** (configured previously via Terraform).
- Proper **IAM credentials** on the control machine to manage the EKS cluster.
- Ansible installed on the control machine (`sudo apt install ansible -y`).
- Make sure `kubernetes` python module is installed: `pip3 install kubernetes`.

## 1. Configure the Inventory

Open `inventory/hosts.ini` and update the variables under the `[eks_admin:vars]` section with your actual details:
- `aws_region`: AWS Region of your EKS cluster.
- `cluster_name`: Name of your EKS cluster.
- `argocd_repo_url`: URL of the GitHub repo containing your Kubernetes manifests.
- `app_namespace`: Custom namespace for your DevConnect app.

## 2. Execute Playbooks

Make sure you run these from the `ansible-devconnect` directory.

### Step 1: Install Required Tools
This will install `aws-cli`, `kubectl`, `helm`, and `eksctl` locally on the control machine.

```bash
ansible-playbook playbooks/install-tools.yml --ask-become-pass
```

### Step 2: Configure kubectl and Namespaces
This fetches the `kubeconfig` to allow local `kubectl` to talk to EKS, and sets up required namespaces (`devconnect` and `argocd`).

```bash
ansible-playbook playbooks/setup-kubectl.yml
```

### Step 3: Install and Configure ArgoCD
This installs ArgoCD via Helm, sets the service type to `LoadBalancer`, retrieves the admin password dynamically, and finally registers your GitOps Repository Application.

```bash
ansible-playbook playbooks/install-argocd.yml
```
*(Check the output of this playbook. It will display the ArgoCD LoadBalancer URL and initial admin password.)*

### Step 4: Deploy the App (Optional)
ArgoCD will automatically start syncing exactly 3 minutes after the Application is registered. You can run this playbook to attempt a manual sync if you have the `argocd` CLI installed, though it's not strictly necessary.

```bash
ansible-playbook playbooks/deploy-app.yml
```
