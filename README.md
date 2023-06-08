# ***Introduction***
This project provides the necessary infrastructure as code using Terraform to deploy a Ghost blog application on Azure Kubernetes Service (AKS).

# ***Components***

- ***Terraform***: It is used to provision the whole infra-structure on Azure.

- ***Azure AKS Cluster***: It hosts the application.

- ***Application Gateway Ingress Controller***: An ingress controller will be installed in the AKS cluster to manage inbound traffic and route it to the appropriate services. This will enable external access to the Ghost blog application.

- ***SSL Certificate***: To secure the application, an SSL/TLS certificate is issued by Letsencrypt certificate authority and configured with the ingress controller.

- ***MySQL Database***: It uses a MySQL Managed Database instance to store the ghost database.

- ***Private network communication***: All the network communication between the AKS and the MySQL goes through private network.

- ***Azure Devops Repo and Pipelines***: The pipelines have been created and tested to run on Azure Devops ecosystem.

# ***Application Diagram***
![Infrastructure Diagram](diagram.jpg =700x600)

# ***Pre requisites***
Before you begin, ensure you have the following prerequisites:

1. Azure subscription: You'll need an active Azure subscription to create the required resources.
2. Azure Devops tenant (Optional): You can run the deploy even locally if you want.
3. Terraform: Install Terraform on your local machine.[https://developer.hashicorp.com/terraform/downloads]
4. Public Domain Name (Optional): Only if you want to have an certificate and a domain assigned to your Application. 

# ***Build and Test***

You have the option to deploy it either though Azure Devops or locally in your laptop.

## ***Running on Azure Devops***

1. Create an Azure Devops Project.
2. Within the project, create variable group called **DEV**.
3. Within the variable group, create an variable name called **GhostAppPassword** with a random password.
4. Create 2 Pipelines (`/pipelines/infra.yml` and `/pipelines/infra.yml`)
5. Within the Azure Devops Project, create 2 environments (DEV and Default) with an approval gate on DEV.
6. Create a Storage Account with 2 containers (`ghostapp-statefile` and `aks-statefile`)
7. Update the files `backend.tf` with the storage account name you just created
8. Update the terraform definitions for your public DNS zone (`dns.tf`, `helms.tf`).
To configure the DNS entry, assign the IP address associated with the Application Gateway.
9. Update the variable file `variables.auto.tfvars` with subscription and tenants ids.
10. Within the Azure Devops Project, create a service connection called **DEV** with `Contributor` permissions within your subscription.
11. Trigger the pipelines in the correct sequence (1-Infra and 2-Applications)

## ***Running locally***

If you want to run it locally in your laptop.

1. Follows the steps 6, 7, 8 and 9 from the previous procedure.
2. In the file **variables.auto.tfvars**, add the variable **GhostAppPassword**
3. Run the terraform commands below within the folders Infra and Applications.

```
terraform init
terraform plan -var-file ..\variables.auto.tfvars
terraform apply -var-file ..\variables.auto.tfvars

```

**_NOTE:_** The SSL validation (cert-manager/letsencrypt) will depend on the correct configuration of the Domain and nameservers.

## ***Validations***

1. Check if the Application is running healthy.

```
kubectl -n ghost get pods
NAME                        READY   STATUS    RESTARTS   AGE
ghost-app-c7bc576d4-zjfxd   1/1     Running   0          22h`
```

2. Check if the ingress has been created successfully

```
kubectl -n ghost get ingress
NAME                CLASS    HOSTS                           ADDRESS       PORTS     AGE
app-ghost-ingress   <none>   blog.fabriziozavalloni.com.br   20.13.86.32   80, 443   2d6h
```

3. Check if the SSL certificate has been issued.

```
kubectl -n ghost get certificates
NAME                     READY   SECRET                   AGE
keyvault-ingress-ghost   True    keyvault-ingress-ghost   2d6h
```

# ***Issues?***

1. If you don't want to use SSL, just flip this setting in the ingress.
It will allow you to navegate in the port 80

`appgw.ingress.kubernetes.io/ssl-redirect: false`

2. If your terraform is not able to connect to your tenant run these commands in your shell.

```
az login

az account set --subscription DEV

```
