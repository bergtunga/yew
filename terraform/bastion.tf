resource "digitalocean_droplet" "bastion" {
    image = var.image
    name = "bastion-${var.name}-${local.env["TF_VAR_REGION"]}"
    region = local.env["TF_VAR_REGION"]
    size = var.bastion_size
    ssh_keys = [data.digitalocean_ssh_key.do_ssh_key.id]
    vpc_uuid = digitalocean_vpc.web.id
    tags = ["${var.name}-bastion"]

    user_data = <<TXT
    #cloud-config
    ${jsonencode({
      users = [
        {
          name = local.env["TF_VAR_USERNAME"]
          sudo = null
          shell = "/bin/bash"
          ssh_authorized_keys = [
            data.digitalocean_ssh_key.do_ssh_key.public_key
          ]
          ssh_keys = {
            rsa_private = local.bastion_key
            rsa_public = local.bastion_key_pub
          }
        }
      ]
      package_upgrade = true
      package_reboot_if_required = true
    })}
    TXT
}


resource "digitalocean_record" "bastion" {
  domain = data.digitalocean_domain.web.name
  type = "A"
  name = "bastion-${var.name}-${local.env["TF_VAR_REGION"]}"
  value  = digitalocean_droplet.bastion.ipv4_address
  ttl=var.ttl
}