data "digitalocean_ssh_key" "do_ssh_key" {
  name = local.env["TF_VAR_SSH_KEY_NAME"]
}

data "digitalocean_domain" "web" {
  name=local.env["TF_VAR_DOMAIN"]
}

