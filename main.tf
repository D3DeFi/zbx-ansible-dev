### Variables used in the Terraform configuration - override in terraform.tfvars
variable "do_token" {
    description = "API token for access to DigitalOcean (generate in API->Tokens/Keys)"
}

variable "do_image" {
    description = "Slug/image-id of distribution to install"
    default     = "ubuntu-16-04-x64"
}

variable "do_region" {
    description = "Slug/region-id of region where to spawn droplet"
    default     = "fra1"
}

variable "do_size" {
    description = "Slug/size-id with which to provision droplet"
    default     = "s-1vcpu-1gb"
}

variable "do_ssh_keys" {
    description = "List of SSH key IDs to load to droplet"
    default     = []
}

variable "do_bastion_host" {
    description = "If bastion host is required to connect to the host"
    default     = ""
}


### Resource and provider definitions for DigitalOcean
provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_tag" "zbx-dev" {
    name = "zbx-dev"
}

resource "digitalocean_droplet" "zbx-dev" {
    count       = 3
    image       = "${var.do_image}"
    name        = "zbx-dev-node00${count.index + 1}"
    region      = "${var.do_region}"
    size        = "${var.do_size}"
    ssh_keys    = "${var.do_ssh_keys}"
    tags        = ["${digitalocean_tag.zbx-dev.name}"]

    provisioner "remote-exec" {
        inline = [
            "sleep 5",
            "apt -q update",
            "apt install -y python3",
        ]

        connection {
            type            = "ssh"
            host            = "${self.ipv4_address}"
            user            = "root"
            agent           = "true"
            bastion_host    = "${var.do_bastion_host}"
        }
    }

    provisioner "local-exec" {
        command = "echo ansible_host: ${self.ipv4_address} > host_vars/${self.name}"
    }

    provisioner "local-exec" {
        command = "touch host_vars/${self.name} && rm host_vars/${self.name}"
        when    = "destroy"
    }
}

### Output definitions for DigitalOcean resources
output "ip" {
    description = "Returns IP addresses assigned to newly created droplets"
    value       = "${digitalocean_droplet.zbx-dev.*.ipv4_address}"
}
