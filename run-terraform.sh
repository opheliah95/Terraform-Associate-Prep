#!/bin/bash

# current file path for this repo
workspace="workspace" # default workspace value

# assign default var file value if not exist already
terraform_var_file="aws.tfvars"

while getopts "wp" arg; do
  case $arg in
    w|--workspace) 
        echo $arg ${OPTARG}
        workspace=$OPTARG;;
    p|--pwd)
        current_dir=$OPTARG;;
    -vf|--var-file)
        terraform_var_file="${$OPTARG:-aws.tfvars}";;
    *)
        error="$1 is not a valid argument.\
                script usage: \
                [-w somevalue] [-p somevalue] [-vf somevalue]"
        echo $error
        exit ;;

  esac
done

# do not attach multipe workspace path
[[ $PWD == *"${workspace}"* ]] \
    && current_dir=$PWD \
    || current_dir=$PWD/${workspace}



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
