# **Section-10-01: Amazon EBS CSI Driver Install on EKS (with Pod Identity)**

---

## **Step-01 – Learning Objectives**

1. Create a **trust policy file** for the EBS CSI Driver IAM Role.
2. Create the IAM Role and attach the **AmazonEBSCSIDriverPolicy** managed policy.
3. Create a **Pod Identity Association** for the EBS CSI controller ServiceAccount.
4. Install the **Amazon EBS CSI Driver add-on** using AWS CLI.
5. Verify installation using `kubectl`.

---

### AWS EBS CSI Driver Architecture

![AWS EBS CSI Driver Architecture](../../images/10-01-EBS-CSI-Driver-Architecture.png)


---

## **Step-02 – Install Amazon EBS CSI Driver (AWS CLI Method)**

### **Step-02-01: Export Environment Variables**

```bash
# Replace the placeholders below with your actual values
export AWS_REGION="us-east-1"
export EKS_CLUSTER_NAME="retail-dev-eksdemo1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AWS_ACCOUNT_ID
```

---

### **Step-02-02: Create Trust Policy File**

```bash
mkdir -p iam-policy-json-files
cd iam-policy-json-files
```

```bash
cat <<EOF > ebs-csi-driver-trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  ]
}
EOF
```

✅ This trust policy lets **EKS Pods (via Pod Identity Agent)** assume the role.

---

### **Step-02-03: Create IAM Role and Attach Policy**

```bash
# Create IAM Role
aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME} \
  --assume-role-policy-document file://ebs-csi-driver-trust-policy.json

# Attach IAM Policy to IAM Role
aws iam attach-role-policy \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME} \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy

# Verify:
aws iam list-attached-role-policies \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}
```

---

### **Step-02-04: Create Pod Identity Association (required for CLI install)**

```bash
# Create EKS Pod Identity Assocication
aws eks create-pod-identity-association \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --namespace kube-system \
  --service-account ebs-csi-controller-sa \
  --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}
```

✅ This binds the IAM role to the `ebs-csi-controller-sa` ServiceAccount
so the EBS CSI Driver can obtain credentials through the Pod Identity Agent.

---

### **Step-02-05: Install the EBS CSI Driver Add-on**

```bash
# List existing EKS add-ons
aws eks list-addons --cluster-name ${EKS_CLUSTER_NAME}

# Install EKS EBS CSI Addon
aws eks create-addon \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}
```

✅ This command:
* Installs the Amazon EBS CSI Driver add-on on your EKS cluster.
* Associates it with the IAM Role you created earlier.
* Deploys the following components automatically:
    * **ebs-csi-controller (Deployment)** 
    * **ebs-csi-node (DaemonSet)**

---

### **Step-02-06: Verify Installation**

```bash
# List EKS add-ons (after install)
aws eks list-addons --cluster-name ${EKS_CLUSTER_NAME}

# Describe Addon - Verify Status
aws eks describe-addon \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --addon-name aws-ebs-csi-driver \
  --query "addon.status" --output text
```

✅ Expected: `ACTIVE`

```bash
kubectl get pods -n kube-system | grep ebs-csi
kubectl get ds   -n kube-system | grep ebs-csi
kubectl get deploy -n kube-system | grep ebs-csi
```

Example:

```
ebs-csi-controller-xxxx   6/6 Running
ebs-csi-node-xxxx         3/3 Running
```

---

### **Step-02-07: Summary**

| Component                    | Command Created                           | Purpose                                |
| ---------------------------- | ----------------------------------------- | -------------------------------------- |
| **IAM Role**                 | `aws iam create-role`                     | Grants EBS CSI Driver AWS permissions  |
| **Policy Attachment**        | `aws iam attach-role-policy`              | Adds `AmazonEBSCSIDriverPolicy`        |
| **Pod Identity Association** | `aws eks create-pod-identity-association` | Binds role → ServiceAccount            |
| **EKS Add-on**               | `aws eks create-addon`                    | Deploys EBS CSI controller & node pods |
| **Verification**             | `kubectl get pods`                        | Confirms add-on Running                |

---

