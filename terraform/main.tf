terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider digitalocean {
    token = local.env["TF_VAR_DO_TOKEN"]

}