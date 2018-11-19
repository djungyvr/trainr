init:
	cd data; terraform init
	cd data/snapshot; terraform init
apply-data:
	cd data; terraform apply -var-file="../secrets.tfvars"
create-snapshot:
	cd data/snapshot; terraform apply \
 		-var-file="../../secrets.tfvars"
destroy:
	cd data; terraform destroy -var-file="../secrets.tfvars"
destroy-snapshot:
	cd data/snapshot; terraform destroy \
 		-var-file="../../secrets.tfvars"
