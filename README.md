#Control Machine (Where the scripts are executed)
	Create a Linux VM or use a Linux Workstation to execute scripts. (Linux distribution should be Redhat)

# Accessing the VM
	Logging to the VM using the root user. This is a must and makes sure your current working directory is "/root" if not change
	your working directory to "/root" by using cd /root/

# Downloading the Answer file 
	URL:https://github.com/tilandesilva/LSEG-work/raw/main/answer.tar.gz
	using the below command download the answer.tar.gz file
	wget https://github.com/tilandesilva/LSEG-work/raw/main/answer.tar.gz 
	(If you get an error that wget is not available install the wget using "yum -y install wget") 
	Using the following command unzip the answer.tar.gz file
	"tar xzvf answer.tar.gz"
	change the working directory to the answer directory using the following command.
	"cd answer"

# Installing Basic requirement Packages
	Download and install the following packages.
	1. Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
	2. Ansible (https://stackoverflow.com/questions/32048021/yum-what-is-the-message-no-package-ansible-available)
	3. Ansible-galaxy collection community.general (sudo ansible-galaxy collection install community.general)
	4. Ansible-galaxy collection amazon.aws (sudo ansible-galaxy collection install amazon.aws)
	5. Python-pip (sudo yum -y install python3-pip)
	6. Boto3 (pip3 install boto3)

	or simply execute the dependencies.sh script which is in the "answers" directory in order to download and install the above packages. 
	For that run the following commands
	"chmod +x dependecies.sh"
	"./dependecies.sh"

# Generating RSA keys
	To establish the secure connection between the control node and web servers create the RSA key using the below command. 
	This should be done under the root user.
	"ssh-keygen -t rsa" (*The public key must be in /root/.ssh/id_rsa.pub*)

#Creating AWS IAM user
	Follow the below link to create an IAM user with full permission
	URL: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console

#Installing and Configuring AWS CLI
	Follow the below links to install and configure AWS CLI. 
	CLI installing instructions: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
	CLI configuring instruction: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

# Provisioning AWS resources
	Make sure that your current working directory is set to answers directory
	Before running terraform files Install the required plugins by using the below command
	"terraform init" (this should be executed under answer directory)
	
	Before executing terraform file run the terraform execution plan to make sure that what will be created. For that run below command
	"terraform plan"

	Execute the terraform script in order to create the required AWS resources run the below command
	"terraform apply --auto-approve"

	If all the steps mentioned above have been completed successfully the newly created AWS ec2 instances can be accessed using ssh without a password.
	after executing terraform the public IPs of the ec2 instances will be displayed. Using them try to ssh using the below command.
	"ssh ec2-user@<IP>"

# Running Ansible file
	After testing the connection to the ec2 instances, to install the web service on the ec2 instance execute the "apache-install.yml" file.
	before executing the yml file open the inventory file which is in the answer directory and make sure one of public IP of ec2 instance is available on it.
	If not copy the IP address and paste them under "[dev]" tag.

	Then run the ansible file using the following command
	"ansible-playbook apache-install.yml -i inventory"

	Other ansible files will be added to the crontab after executing the "apache-install.yml" file.
	if the other two ansibles files are needed to be executed instead of cron job run the following commands.
	"ansible-playbook webserver-status-check.yml -i inventory"
	"ansible-playbook log-save.yml -i inventory"


