#!/bin/bash

# current file path for this repo
workspace="workspace"
[[ $PWD == *"$workspace"* ]] \
    && current_dir=$PWD \
    || current_dir=$PWD/${workspace}

# assign default var file value if not exist already
terraform_var_file="${1:-aws.tfvars}"

# some debug to test if the resoruces exist
echo "current directory is ${current_dir}"
echo "the variable file is ${terraform_var_file}"

# exec terraform apply function in dir with terraform
function terraform_apply(){
    cd ${current_dir}
    terraform apply --var-file=${terraform_var_file} --auto-approve
}

# exec terraform show function in dir with terraform
function terraform_show(){
    cd ${current_dir}
    terraform show
}

# exec terraform destroy 
function terraform_destroy(){
    cd ${current_dir}
    terraform destroy --var-file=${terraform_var_file} --auto-approve
}

# exec terraform plan to show update
function terraform_plan(){
    cd ${current_dir}
    terraform plan --var-file=${terraform_var_file} 
}
