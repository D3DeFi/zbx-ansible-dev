Description
-----------

Collection of ansible playbooks, terraform configurations and scripts to spin up testing instances of Zabbix servers in cloud. Currently supported:

* DigitalOcean

Prerequisities
--------------

1. Following tools should be present:
    * terraform ([doc](https://www.terraform.io/intro/getting-started/install.html))
    * python2.7+ or python3+
    * pip ([doc](https://pip.pypa.io/en/stable/installing/#installing-with-get-pip-py))
    * (optional) virtualenv (`pip install virtualenv`)
    * (optional if using zabbix\_map) libtff-dev libjpeg-dev zlib-dev

2. Create virtualenv (optional) and install requirements
```bash
virtualenv env
source env/bin/activate
pip install -r requirements.txt
```

3. Any variables from `main.tf` should be overriden in `terraform.tfvars`. Required minimum is:
```ini
do_token    = "API_TOKEN_STRING"
do_ssh_keys = [SSH_KEY_ID]
```

4. Finalize by downloading required ansible roles and initializing terraform:
```bash
terraform init
ansible-galaxy install -r requirements.yml
```

Usage
-----

1. Deploy testing infrastructure
```bash
terraform plan
terraform apply
```

2. If there is need for bastion host and it was configured to `terraform.tfvars`:
```bash
source scripts/setup-bastion.sh
# source scripts/setup-bastion.sh HOST  # if do_bastion_host is not set
```

3. Provision via ansible-playbook:
```
source env/bin/activate  # if using virtualenv
ansible-playbook site.yml
```
