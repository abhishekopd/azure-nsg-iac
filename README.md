# Deployment of NSG Rules using IaC - Terraform
In today's cloud-based infrastructure, network security is of utmost importance. Network Security Groups (NSGs) play a crucial role in securing virtual networks in Azure. NSGs allow or deny network traffic to and from Azure resources based on user-defined rules. In this article, we will explore how to deploy NSG rules using Infrastructure as Code (IaC) with Terraform and Azure Pipelines.

# Why use IaC for NSG Rules?
Adding Network Security Group (NSG) rules using Infrastructure as Code (IaC) is generally considered better than doing it manually from the portal for several reasons:
- Consistency and Reproducibility: With IaC, NSG rules can be defined in a declarative manner using code, which ensures consistency across environments. The same set of rules can be easily reproduced and applied to multiple NSGs, reducing the risk of human error and ensuring that the desired configuration is consistently applied.
- Version Control and Auditing: IaC allows you to store the NSG rules in a version control system, providing a history of changes and the ability to roll back to previous versions if needed. This enables better tracking, auditing, and collaboration among team members, ensuring that changes are documented and can be reviewed.
- Automation and Efficiency: IaC enables automation of the NSG rule deployment process. By defining the rules in code, you can leverage automation tools and pipelines to deploy and manage NSG rules at scale. This reduces manual effort, saves time, and improves efficiency compared to manually configuring rules through the portal.

# Folder Structure
To organize our Terraform code and configuration files based on environments, we will follow a specific folder structure. Here's an overview of the structure:
```
.
│   azure-pipeline.yml
│   main.tf
│   README.md
│   variables.tf
│
├───DEV
│       terraform-aks-dev.tfvars.json
│       terraform-apim-dev.tfvars.json
│
├───PROD
│       terraform-aks-prod.tfvars.json
│
└───QC
        terraform-aks-qc.tfvars.json
```
- main.tf: This is the main Terraform configuration file that defines the NSG rules. 
    - In this configuration, we define the backend for storing the Terraform state files in an Azure Storage Account. Make sure to replace the placeholders (`SA_RG`, `SA_NAME`, `NSG/nsg.tfstate`) with the appropriate values for your environment.
    - The `azurerm` provider block configures the Azure provider for Terraform.
    - The `locals` block defines a local variable `nsg_rules` that references the `var.nsg_rules` variable defined in the variables.tf file.
    - The `azurerm_network_security_rule` resource block creates the NSG rules based on the values provided in the `nsg_rules` variable. Each rule is defined as a separate key-value pair in the nsg_rules variable.

- variables.tf: This file defines the variables used in the Terraform configuration.
    - In this file, we define the following variables:
        1. nsg_rules: A map of NSG rules, where each rule is defined as an object with various properties such as priority, direction, access, protocol, etc.
        2. nsg_name: The name of the NSG.
        3. resource_group_name: The name of the resource group where the NSG is located.

- azure-pipeline.yml: This file contains the Azure Pipeline configuration for continuous integration and deployment.

- README.md: This file contains the documentation for the deployment process.

# NSG Rule configuration
- To configure the NSG rules, we use `.tfvars.json` files. [Here's](https://github.com/abhishekopd/azure-nsg-iac/blob/main/DEV/terraform-aks-dev.tfvars.json) an example of the configuration for the dev8080Rule and dev443Rule rules.
- In this configuration, we define the `nsg_rules` object with the specific NSG rules. Each rule is defined as a key-value pair, where the key is the rule name and the value is an object containing the rule properties.

# Deployment process
- The deployment process consists of 2 stages: `GitModifiedFilesStage` and `Terraform apply (Deploy $Env)`.
- In the `GitModifiedFilesStage`, the pipeline identifies the modified files in the repository and categorizes them based on their prefixes (dev, qc, prod). It creates separate text files (dev.txt, qc.txt, prod.txt) to store the names of the modified files. These text files are then published as build artifacts.
- The deployment stages are conditionally executed based on the presence of modified files in the respective categories (dev, qc, prod). 

