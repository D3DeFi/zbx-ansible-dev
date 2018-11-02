Description
-----------

Collection of ansible playbooks and scripts to spin up testing instances of Zabbix servers in cloud. Currently supported:

* DigitalOcean

Installation
------------

Ensure you have atleast python>=2.7, virtualenv and pip installed, then run:

```yaml
  virtualenv env
  source env/bin/activate
  pip install -r requirements.txt
```

Fill in details in `inventory` file:

```ini
[zabbix-nodes]
# Add as many hosts as you want here, but use unique names to prevent ansible from deploying to your existing VMs

[all:vars]
# Generate new API token at https://cloud.digitalocean.com/account/api/tokens
digital_ocean_api_token=''

# Set these here or per host basis, provided values are just examples
# use gather-do-info.yml playbook if you don't know what to fill in
digital_ocean_region='ams3'
digital_ocean_image='ubuntu-16-04-x64'
digital_ocean_size='s-1vcpu-1gb'
# Requires list of SSH key IDs delimited by comma - make sure at least one SSH key is present in your account at https://cloud.digitalocean.com/account/security
digital_ocean_ssh_keys='10101,10102,10103'
```
