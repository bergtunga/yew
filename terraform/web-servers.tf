resource "digitalocean_droplet" "web" {
    count = var.droplet_count
    image = var.image
    name = "web-${var.name}-${local.env["TF_VAR_REGION"]}-${count.index + 1}"
    region = local.env["TF_VAR_REGION"]
    size = var.droplet_size
    ssh_keys = [data.digitalocean_ssh_key.do_ssh_key.id]
    vpc_uuid = digitalocean_vpc.web.id
    tags=["${var.name}-webserver"]
    # user_data = <<TXT
    # #cloud-config
    # packages:
    #     - postgresql
    # runcmd:
    #     - [sh, -xc, "echo '<h1>web-${local.env["TF_VAR_REGION"]}-${count.index + 1}</h1>' >> /var/www/html/index.html"]
    # runcmd:
    #     - [sh, -xc, "echo '<h1>web-${local.env["TF_VAR_REGION"]}-${count.index + 1}</h1>' >> /var/www/html/index.html"]
    
    # ${file("../dist")}
    # TXT

    user_data = <<TXT
    #cloud-config
    packages:
    - nginx
    - postgresql
    write_files:
    ${local.dist}
    TXT
    graceful_shutdown = false

    lifecycle {
      create_before_destroy = true
    }
    # provisioner "file" {
    #   source = "../dist/"
    #   destination = "/var/www/html/"
    #   connection {
    #     type = "ssh"
    #     user = "root"
    #     host = self.ipv4_address
    #     bastion_host = digitalocean_droplet.bastion.id
    #     bastion_certificate = data.digitalocean_ssh_key.do_ssh_key.id
    #   }
    #   on_failure = continue
    # }
}

resource "digitalocean_certificate" "web" {
  name = "${var.name}-certificate"
  type = "lets_encrypt"
  # domains = ["${local.env["TF_VAR_SUBDOMAIN"]}.${data.digitalocean_domain.web.name}"]
  domains = ["${data.digitalocean_domain.web.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_loadbalancer" "web" {
  name="web-${local.env["TF_VAR_REGION"]}"
  region=local.env["TF_VAR_REGION"]
  droplet_ids = digitalocean_droplet.web.*.id
  vpc_uuid = digitalocean_vpc.web.id
  redirect_http_to_https = true
  lifecycle {
    create_before_destroy = true
  }
  forwarding_rule {
    entry_port = 443
    entry_protocol = "https"
    target_port = 80
    target_protocol = "http"
    certificate_name = digitalocean_certificate.web.name
  }
  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"
    target_port = 80
    target_protocol = "http"
    certificate_name = digitalocean_certificate.web.name
  }
}

resource "digitalocean_firewall" "web" {
    name = "${var.name}-vpc-traffic" # Firewall name

    droplet_ids = digitalocean_droplet.web.*.id # Droplets firewall applies to

    # Internal vpc rules, permit internal communication
    inbound_rule {
      protocol = "tcp"
      port_range = "1-65535"
      source_addresses = [digitalocean_vpc.web.ip_range]
    }
    inbound_rule {
      protocol = "udp"
      port_range = "1-65535"
      source_addresses = [digitalocean_vpc.web.ip_range]
    }
    inbound_rule {
      protocol = "icmp"
      source_addresses = [digitalocean_vpc.web.ip_range]
    }
    outbound_rule {
      protocol = "tcp"
      port_range = "1-65535"
      destination_addresses = [digitalocean_vpc.web.ip_range]
    }
    outbound_rule {
      protocol = "udp"
      port_range = "1-65535"
      destination_addresses = [digitalocean_vpc.web.ip_range]
    }
    outbound_rule {
      protocol = "icmp"
      destination_addresses = [digitalocean_vpc.web.ip_range]
    }

    # outbound traffic
    outbound_rule { # DNS
      protocol = "udp"
      port_range = "53"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }
    outbound_rule { # HTTP
      protocol = "tcp"
      port_range = "80"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }
    outbound_rule { # HTTPS
      protocol = "tcp"
      port_range = "443"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }
    outbound_rule { # ICMP/Ping
      protocol = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }

}

resource "digitalocean_record" "web" {
  domain = data.digitalocean_domain.web.name
  type = "A"
  name = local.env["TF_VAR_SUBDOMAIN"]
  value = digitalocean_loadbalancer.web.ip
  ttl=var.ttl 
}