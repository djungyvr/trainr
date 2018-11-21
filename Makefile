init:
	cd data; terraform init
	cd data/snapshot; terraform init
	cd trainr; terraform init

init-tutorial:
	cp tutorial/collect.sh data/collect.sh
	cp tutorial/cifar.py trainr/cifar.py
	cp tutorial/train.sh trainr/train.sh

create-data:
	cd data; terraform apply -var-file="../secrets.tfvars"

create-snapshot:
	$(eval VOLUME_ID := $(shell cd data; terraform output volume_id))
	cd data/snapshot; terraform apply \
		-var volume=$(VOLUME_ID) \
		-var-file="../../secrets.tfvars"
	cd data; terraform destroy -var-file="../secrets.tfvars"

destroy-data:
	cd data; terraform destroy -var-file="../secrets.tfvars"

destroy-snapshot:
	$(eval VOLUME_ID := $(shell cd data/snapshot; terraform output volume_id))
	cd data/snapshot; terraform destroy \
		-var volume=$(VOLUME_ID) \
		-var-file="../../secrets.tfvars"

train:
	$(eval SNAPSHOT_ID := $(shell cd data/snapshot; terraform output snapshot_id))
	cd trainr; terraform apply \
		-var snapshot=$(SNAPSHOT_ID) \
		-var-file="../secrets.tfvars"

destroy-train:
	$(eval SNAPSHOT_ID := $(shell cd data/snapshot; terraform output snapshot_id))
	cd trainr; terraform destroy \
		-var instance_type=foo \
		-var keras_script=foo \
		-var snapshot=$(SNAPSHOT_ID) \
		-var-file="../secrets.tfvars"
