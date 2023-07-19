resource "digitalocean_droplet" "bastion" {
    image = var.image
    name = "bastion-${var.name}-${local.env["TF_VAR_REGION"]}"
    region = local.env["TF_VAR_REGION"]
    size = var.bastion_size
    ssh_keys = [data.digitalocean_ssh_key.do_ssh_key.id]
    vpc_uuid = digitalocean_vpc.web.id
    user_data = <<TXT
    #cloud-config
    users:
    - name: ${local.env["TF_VAR_USERNAME"]}
      sudo: false
      ssh_authorized_keys:
        - ${data.digitalocean_ssh_key.do_ssh_key.public_key}
    package_update: true
    package_upgrade: true
    TXT
}


resource "digitalocean_record" "bastion" {
  domain = data.digitalocean_domain.web.name
  type = "A"
  name = "bastion-${var.name}-${local.env["TF_VAR_REGION"]}"
  value  = digitalocean_droplet.bastion.ipv4_address
  ttl=var.ttl
}