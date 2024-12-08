# Nix Darwin Config

## Installation

Install nix using the Determinate Systems installer.

```bash {"name":"Nix Install"}
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

## Configure

Apply the nix-darwin config

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
```

Now darwin-rebuild command will be available, we can just run

```bash
darwin-rebuild switch --flake .
```
