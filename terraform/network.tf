resource "digitalocean_vpc" "web" {
    name="${var.name}-app"
    region=local.env["TF_VAR_REGION"]
    ip_range = "192.168.69.0/24"
}