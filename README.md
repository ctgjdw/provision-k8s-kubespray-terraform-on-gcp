# Provision Kubernetes Cluster on GCP Compute Engine with Kubespray and Terraform

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [gcloud](https://cloud.google.com/sdk/install)
- [kubespray](https://github.com/kubernetes-sigs/kubespray)

## Steps

1. Clone the repository

```bash
git clone https://github.com/ctgjdw/provision-k8s-kubespray-terraform-on-gcp.git
```

2. Change directory to the repository

```bash
cd gcp-k8s-cluster
```

3. Create `terraform.tfvars` from the example `terraform.tfvars.example`. Edit with your GCP project ID, region, and zone.

```bash
cp terraform.tfvars.example terraform.tfvars`
```

4. Run `terraform init` to initialize the Terraform configuration.

```bash
terraform init
```

5. Run `terraform plan` to see the changes that will be made.

```bash
terraform plan
```

6. Run `terraform apply` to create the resources.

```bash
terraform apply
```

7. Clone [kubespray](https://github.com/kubernetes-sigs/kubespray) and checkout to `release-2.30` branch.

```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout release-2.30
```

8. Copy `gcp-k8s-vms/kubespray-ansible-2.30` to `kubespray/inventory/gcp`.

9. Edit the configs in `kubespray/inventory/gcp/group_vars/k8s_cluster/k8s-cluster.yml`

10. SSH into your GCP Compute Engine instances to verify the ssh connection.

```bash
gcloud compute instances list
gcloud compute ssh "<NODE_NAME>"
```

11. Install the required Python packages.

```bash
pip install -r requirements.txt
```

12. Run the playbook to provision the Kubernetes cluster.

```bash
ansible-playbook -i inventory/gcp/hosts.ini -b -v --private-key=~/.ssh/google_compute_engine playbooks/cluster.yml
```

13. Copy the `inventory/gcp/artifacts/admin.conf` file to `~/.kube/config`

14. Verify the cluster
