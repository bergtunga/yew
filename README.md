# Yew
This is a Yew app that's built with [Trunk] and [Tailwind]  
I am experimenting with developing a webpage with Rust/Web assembly, as well as [Terraform]

## Usage

[See it Live!][mywebsite]

## Environment Configuration
(This repo is private. Gotta get started again? I hope you kept it up to date...)

Install Rust: <https://www.rust-lang.org/tools/install>

To compile Rust to WASM, we need `wasm32-unknown-unknown` installed.
To development-serve, install and run via cargo
For deployment infastructure, use terraform

```bash
# rustup compiles the rust -> wasm transpiler
rustup target add wasm32-unknown-unknown
# package manager to install trunk and the other thing?
cargo install trunk wasm-bindgen-cli

# Terraform. Copied from https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
```

## Local Development (Contribution)

```bash
# Rebuilds on rust change and hosts a local server.
trunk serve
# Rebuilds on css change and hosts a local server.
npx tailwindcss -i ./src/resource/main.css -o ./main.css --watch
```

## Deploy and Release
Populate the terraform/.env.sample file and rename to .env

```sh
# To set up infastructure
cd terraform && terraform apply

# to deploy to infastructure
./deploy.sh
```

This builds the app in release mode similar to `cargo build --release`.
You can also pass the `--release` flag to `trunk serve` if you need to get every last drop of performance.

Unless overwritten, the output will be located in the `dist` directory.

[trunk]: https://github.com/thedodd/trunk
[tailwind]: https://github.com/tailwindlabs/tailwindcss
[terraform]: https://github.com/hashicorp/terraform
[mywebsite]: https://AndrewTung.com/