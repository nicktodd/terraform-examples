# Deploying an autoscaled cluster of EC2 instances using Terraform

In this exercise, you will see how Terraform can be used to deploy an autoscaled cluster of instances that are behind a load balancer.

## Prerequisites
To complete this exercise, you must be using a machine that already has access to AWS resources through the AWS CLI. For example, you have already set up your environment and permissions using `aws configure`, or you are using an EC2 machine that has the necessary permissions through the Role that it is running with.

The machine you are on will also need Terraform already installed. 

## Part 1 Create a Terraform Project

1. Create a new folder on your machine where you wish to put your exercise. A name like `autoscale-terraform-example` for example.

Terraform projects typically contain a number of standard files such as:

+ main.tf
+ variables.tf
+ outputs.tf

The `main.tf` file is where you set up your resources, the `variables.tf` file is where you configure any parameters that could be changed when running the deployment, such as instance size, and `outputs.tf` which specifies any values that are output when the deployment has been completed, such as the URL of the load balancer of the running application.

2. Open the folder in your preferred IDE, and in your new folder, create a file called `variables.tf`.

        If you are using VisualStudio Code, you might want to install the Terraform extension. This will give you intellisense and color coding on your files.



3. Within the file, 













3. At a terminal, CD into the directory and run the following command to initialise the folder for Terraform.

```
terraform init
```



3. 