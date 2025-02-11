#!/usr/bin/env ash

function init_ssh_access() {
  mkdir -p /root/.ssh/
  [ -f /root/.ssh/id_ed25519 ] || cp /run/secrets/id_ed25519 /root/.ssh/ && chmod 0600 /root/.ssh/id_ed25519
  ssh-keyscan "${ESXI_SERVER}" >> /root/.ssh/known_hosts
  ssh-keyscan "${SECURE_SERVER}" >> /root/.ssh/known_hosts
  echo "
    Host ${SECURE_SERVER}
        HostName ${SECURE_SERVER}
        User root
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    " > ~/.ssh/config
}

function init_terraform() {
    mkdir -p /source/
    git clone "${TERRAFORM_REPO}" /source/
    scp -O "${SECURE_SERVER}:${SECURE_PATH}variables.tf" /source
    scp -O "${SECURE_SERVER}:${SECURE_PATH}terraform.tfstate" /source
    ls -all /source/
    scp -Or /source/inventory.yaml "${SECURE_SERVER}:${SECURE_PATH}"
    terraform init -input=false
    terraform providers
}

function plan() {
  terraform plan
  terraform output -json | jq -r 'del(.[]|."sensitive") | del(.[]|."type") | walk(if type == "object" then with_entries( if .key == "value" then .key = "hosts" | .value = (.value | map({(.) : null} )  | add) else . end ) else . end) ' > /source/inventory.json
  scp -Or /source/terraform.tfstate "${SECURE_SERVER}:${SECURE_PATH}"
  scp -Or /source/inventory.json "${SECURE_SERVER}:${SECURE_PATH}"
}

function apply() {
  terraform apply -auto-approve
  terraform output -json | jq -r 'del(.[]|."sensitive") | del(.[]|."type") | walk(if type == "object" then with_entries( if .key == "value" then .key = "hosts" | .value = (.value | map({(.) : null} )  | add) else . end ) else . end) ' > /source/inventory.json
  scp -Or /source/terraform.tfstate "${SECURE_SERVER}:${SECURE_PATH}"
  scp -Or /source/inventory.json "${SECURE_SERVER}:${SECURE_PATH}"
}

init_ssh_access
init_terraform
if [[ "true" == "${APPLY}" ]]
then
  apply
else
  plan
fi


