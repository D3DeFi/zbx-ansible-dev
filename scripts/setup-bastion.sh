#!/bin/bash
# Simple script to slightly change environment if bastion host is required to reach managed nodes

BASTION=$1

if [ -z $BASTION ]
then
    # Attempt to parse bastion host from terraform settings if not provided as cmd-line argument
    TFVARS_FILE=${PWD}/terraform.tfvars
    if [ -f $TFVARS_FILE ]
    then
        BASTION=$(sed -En 's/do_bastion_host\s*=\s*\"(.*)\"/\1/p' < $TFVARS_FILE)
    fi
fi

if [ -z $BASTION ]
then
    echo "Provide bastion host: 'source scripts/setup-bastion.sh bastion.example.com' or set it to terraform.tfvars"
else
    # Define location for custom ssh config file
    SSH_FILE=${PWD}/.ssh_dev_config

    # Wipe out previous SSH bastion configuration
    echo -n > $SSH_FILE

    # Parse ansible host_vars files to get list of available IP addresses and generate host block to $SSH_FILE
    for hostfile in $(ls --color=never ${PWD}/host_vars)
    do
        # Variable hostfile equals to server name
        ipaddr=$(sed -En 's/ansible_host:\s+(([0-9]{1,3}\.){,3}[0-9]{1,3}).*/\1/p' < ${PWD}/host_vars/$hostfile)
        # Build local $SSH_FILE host by host
        cat <<EOF >> $SSH_FILE
Host $ipaddr
  Hostname $ipaddr
  User root
  ProxyCommand ssh -W %h:%p root@$BASTION
  StrictHostKeyChecking no

EOF

    done

    # Generate block for bastion host
    cat <<EOF >> $SSH_FILE
Host $BASTION
  Hostname $BASTION
  User root
  ServerAliveInterval 60
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF

    # Get info about what OS is running locally
    RUNNING_OS=$(uname)  # Linux, CYGWIN_NT*, SunOS

    # Export ANSIBLE_SSH_ARGS to point to newly generated file
    if echo $RUNNING_OS | grep -iq cygwin
    then
        # using SSH multiplexing with Windows is not possible
        export ANSIBLE_SSH_ARGS=" -F $SSH_FILE -o ControlMaster=no"
    else
        export ANSIBLE_SSH_ARGS=" -F $SSH_FILE -o ControlMaster=auto -o ControlPersist=15m"
    fi
fi

