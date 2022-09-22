.PHONY: init plan-test apply-test destroy-test plan-dev apply-dev destroy-dev plan-prod apply-prod destroy-prod
init:
	terraform init
plan-test:
	terraform init
	terraform validate
	terraform plan
apply-test:
	terraform apply
destroy-test:
	terraform destroy
plan-dev:
	terraform init
	terraform validate
	terraform plan -var-file="env/dev.tfvars"
apply-dev:
	terraform apply -var-file="env/dev.tfvars"
destroy-dev:
	terraform destroy -var-file="env/dev.tfvars"
plan-prod:
	terraform init
	terraform validate
	terraform plan -var-file="env/prod.tfvars"
apply-prod:
	terraform plan -var-file="env/prod.tfvars"
destroy-prod:
	terraform destroy -var-file="env/prod.tfvars"