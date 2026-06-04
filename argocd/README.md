# ArgoCD GitOps Setup for DevConnect

This guide walks you through installing ArgoCD on your Kubernetes cluster and configuring it to automatically deploy the DevConnect application using a GitOps approach.

## 1. Install ArgoCD

We have provided scripts to automate the installation of ArgoCD into your cluster.

### For Windows (PowerShell):
```powershell
.\install-argocd.ps1
```

### For Linux/macOS (Bash):
```bash
chmod +x install-argocd.sh
./install-argocd.sh
```

These scripts will:
1. Create a new `argocd` namespace.
2. Install ArgoCD components from the official manifests.
3. Wait for the pods to be ready.
4. Patch the `argocd-server` service to use `NodePort` for easier access.

## 2. Access the ArgoCD UI

1. **Get the initial admin password:**
   The installation script outputs the command to retrieve the password. Run it to get your password.
   - *Windows:* `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | % { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }`
   - *Linux/macOS:* `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

2. **Access the Web UI:**
   Since the service is patched to `NodePort`, you can access it via your node's IP and the randomly assigned node port. You can find the port by running: 
   ```bash
   kubectl get svc argocd-server -n argocd
   ```
   
   Alternatively, you can securely port-forward to your local machine:
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   Now, open your browser and navigate to `https://localhost:8080` (Ignore the self-signed certificate warning).

3. **Login:**
   - **Username:** `admin`
   - **Password:** The password you retrieved in step 1.

## 3. Configure GitOps for DevConnect

Once ArgoCD is running, we need to apply the Application manifest that tells ArgoCD to watch your Git repository.

1. **Push your code to GitHub.**
2. **Open `devconnect-application.yaml`** and update the `repoURL` field with your actual GitHub repository URL (e.g., `https://github.com/myusername/DevConnect.git`).
3. **Apply the Application manifest** to ArgoCD:
   ```bash
   kubectl apply -f devconnect-application.yaml -n argocd
   ```

## 4. How it Works (GitOps Workflow)

1. **Commit and Push:** Whenever you make changes to your Kubernetes manifests (e.g., updating a Docker image tag in the `k8s/` directory), you push those changes to your GitHub repository's main branch.
2. **ArgoCD Sync:** ArgoCD continuously monitors the `k8s/` directory in your GitHub repository.
3. **Automated Deployment:** When ArgoCD detects a difference between the desired state in Git and the actual state in the Kubernetes cluster, it automatically applies the changes because `prune` and `selfHeal` are enabled in the Application manifest.
