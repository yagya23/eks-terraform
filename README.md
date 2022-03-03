# EKS Cluster with Terraform

This repository contains terraform code to spin up EKS cluster. Apart from it, it also makes follwing resources:
- VPC
- Subnets ( 2 Private and 2 Public)
- Internet Gateway
- NAT Gateway 
- Route table
- Route table association
- EKS Cluster with 3 node groups 
- EFS
- Ingress nginx controller with public network load balancer
- Storage class and Persistent Volumne claim bind with Persistent Volume 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>= 0.15 |


## Providers

| Name | Version |
|------|---------|
| <a name="kubernetes"></a> [kubernetes](#hashicorp/kubernetes) | = 2.6.1 |
| <a name="helm"></a> [helm](#hashicorp/helm) | = 2.3.0 |
| <a name="aws"></a> [aws](#hashicorp/aws) | ~> 3.50.0 |

## Modules

No modules.

# Setting env on your machine.

To access cluster or to see resources (sc,pvc,pvc & helm)  install following utilites on your machine.
- [Terraform cli ](https://releases.hashicorp.com/terraform/) : Install terraform cli version v0.15.5
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html) 
- [Helm 3](https://helm.sh/docs/intro/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)

# Configure AWS credentials
Create Access key id and secret from AWS portal to install resources on AWS .
run below command on your terminal to configure credentials

```
$ aws configure
AWS Access Key ID [None]: xxxxxxxxxxxxx  
AWS Secret Access Key [None]: xxxxxxxxxxxxx
Default region name [None]: us-east-1    # specify region
Default output format [None]: json        # specify output format
```
# Run instructions
```
terraform init     # initializes, download providers
terraform plan     # plans out, outputs resources to be deployed
terraform apply    # create resources on terraform
```
# Access cluster url
 To access cluster URL from your machine, need to get EKS cluster kubeconfig,run below command:
 ```
  aws eks --region <region> update-kubeconfig --name <name of eks cluster>
 ```

To get URL from external load balancer, 
```
kubectl get svc -n default
```
Grep url of loadbalancer and run on your browser.

List Storage Class , PVC , PV. 
```
kubectl get sc,pv,pvc
```

List nginx-ingress-controller

```
kubectl get all 
```
