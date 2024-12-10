# Nix Darwin Config

## Installation

Install nix using the Determinate Systems installer.

```bash {"name":"Nix Install"}
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

## Configure

Apply the nix-darwin config from remote:

```bash
nix-shell -p git --run 'git clone https://github.com/gptparv/nix-darwin-config.git ~/nix-config'
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix-config
```

Apply the nix-darwin config from local:

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
```

Now darwin-rebuild command will be available, just run

```bash
darwin-rebuild switch --flake .
```
