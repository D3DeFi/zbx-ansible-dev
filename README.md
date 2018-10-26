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

[all:vars]
digital_ocean_api_token=''
# Set these here or per host basis
digital_ocean_image=''
digital_ocean_region=''
digital_ocean_size=''
digital_ocean_ssh_keys=''

```
