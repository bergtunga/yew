locals {
  env = { for tuple in regexall("(.*?)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
  dist = join("\n", [ 
    for f in fileset("../dist/", "**"):
        <<CLD
        - encoding: b64
          content: ${filebase64("../dist/${f}")}
          path: /var/www/html/${f}
        CLD
    ])
}

variable "droplet_count" {
  default = 1
  type = number
}

variable "name" {
  type = string
  default = "yew"
}

variable "image" {
  type = string
  default = "ubuntu-22-04-x64"
}

variable "droplet_size" {
  type = string
  default = "s-1vcpu-512mb-10gb"
}

variable "bastion_size" {
  type = string
  default = "s-1vcpu-512mb-10gb"
}

# The size we want our database images to be to be.
variable "database_size" {
    type = string
    default = "db-s-1vcpu-1gb"
}
# The number of database nodes to create
variable "db_count" {
    type = number
    default = 1
}

variable "ttl" {
  type = number
  default = 30
}
