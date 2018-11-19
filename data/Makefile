init:
	terraform init
	cd snapshot; terraform init
create:
	terraform apply -var-file="../secrets.tfvars"
create-snapshot:
	cd snapshot; terraform apply \
 		-var-file="../../secrets.tfvars"
destroy:
	terraform destroy -var-file="../secrets.tfvars"
destroy-snapshot:
	cd snapshot; terraform destroy \
 		-var-file="../../secrets.tfvars"
