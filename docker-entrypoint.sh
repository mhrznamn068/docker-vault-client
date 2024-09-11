#!/bin/bash

# set -xe

vault_token=$vault_token # string
vault_server=$vault_server #string
vault_server_connection=$vault_server_connection #string
vault_api_version=$vault_api_version # string
vault_secret_path=${vault_secret_path#/}   # Remove leading /
vault_secret_path=${vault_secret_path%/}   # Remove trailing /
output_to_file=${output_to_file:-True} # boolean
output_file_path=${output_file_path%/} # string
output_file_path=${output_file_path:-/tmp}
output_file_name=${output_file_name:-secrets} # string
json_to_env=${json_to_env:-False} # boolean
env_file_name=${env_file_name:-secrets} # string

function get_secrets () {
    if [[ ! -z "$vault_token" && ! -z "$vault_server" && ! -z "$vault_server_connection" && ! -z "$vault_api_version" && ! -z "$vault_secret_path" ]]; then
      curl -s --header "X-Vault-Token: $vault_token" --request GET \
        $vault_server_connection://$vault_server/$vault_api_version/$vault_secret_path | jq -r ".data"
    else
      echo "Vault details not found, recheck and try again !!!" >&2
      exit 1
    fi
}

function json_env () {
    cat $1/$2 | jq -r 'to_entries|map("\(.key)=\(.value|tostring|gsub("\n";"\\n"))")|.[]' 
}

if [[ "$1" == "gen-secret" ]]; then
  if [[ "$output_to_file" == "True" ]]; then
    get_secrets  > $output_file_path/$output_file_name.json
  elif [[ "$output_to_file" == "False" ]]; then
    get_secrets
  else
    get_secrets
  fi
  
  if [[ "$json_to_env" == "True" && -z "env_file_name" ]]; then
    json_env $output_file_path $output_file_name.json > $output_file_path/.env
  elif [[ "$json_to_env" == "True" && ! -z "env_file_name" ]]; then
    json_env $output_file_path $output_file_name.json > $output_file_path/$output_file_name.env
  else
    echo "Skipping Json to key=value env convert"
  fi
elif [[ "$1" == "sh" ||  "$1" == "bash" ]]; then
  $1
fi