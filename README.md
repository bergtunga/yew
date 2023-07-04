# Yew Trunk
This is a Yew app that's built with [Trunk] and [Tailwind]
I am experimenting with developing a webpage with Rust/Web assembly, as well as [Terraform]

## Usage

visit [My Website][mywebsite]

### Development
(This repo is private. Did you forget?)

Install Rust: <https://www.rust-lang.org/tools/install>

To compile Rust to WASM, we need to have the `wasm32-unknown-unknown` target installed.
To development-serve, installed and run via cargo

```bash
rustup target add wasm32-unknown-unknown
cargo install trunk wasm-bindgen-cli
```

### Running

Rebuilds on change and hosts a local server.
```bash
trunk serve
```

### Release

```bash
trunk build --release
```

This builds the app in release mode similar to `cargo build --release`.
You can also pass the `--release` flag to `trunk serve` if you need to get every last drop of performance.

Unless overwritten, the output will be located in the `dist` directory.

[trunk]: https://github.com/thedodd/trunk
[tailwind]: https://github.com/tailwindlabs/tailwindcss
[terraform]: https://github.com/hashicorp/terraform
[mywebsite]: https://AndrewTung.com/