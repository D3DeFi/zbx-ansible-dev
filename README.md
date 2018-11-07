Description
-----------

Collection of ansible playbooks, terraform configurations and scripts to spin up testing instances of Zabbix servers in cloud. Currently supported:

* DigitalOcean

Prerequisities
--------------

1. Terraform should be set up per [official instructions](https://www.terraform.io/intro/getting-started/install.html)

2. At least python >= 2.7 should be present before running (skip if virtualenv and pip are already present):
```bash
  curl https://bootstrap.pypa.io/get-pip.py > get-pip.py
  python get-pip.py && rm get-pip.py
  pip install virtualenv
```

3. Any variables from `main.tf` should be overriden in `terraform.tfvars`. Minimum required variables are:
```ini
do_token    = "API_TOKEN_STRING"
do_ssh_keys = [SSH_KEY_ID]
```
