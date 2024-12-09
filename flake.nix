{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew }:
    let
      configuration = { pkgs, config, ... }: {
        environment.systemPackages = with pkgs;
          [
            act
            actionlint
            appcleaner
            argo
            argocd
            asdf-vm
            atmos
            azure-cli
            direnv
            dive
            git
            gh
            gh-dash
            ghq
            gnugrep
            hwatch
            jnv
            just
            jq
            jqp
            kubelogin
            lazygit
            mkalias
            mise
            moreutils
            nixpkgs-fmt
            oh-my-posh
            pre-commit
            runme
            safe
            shfmt
            shellcheck
            shellharden
            terraform-compliance
            terraform-docs
            tflint
            thefuck
            tree
            treefmt2
            trivy
            watchman
            watchexec
            vault
            vim
            vscode
            yor
            yq-go
            xcode-install
          ];

        homebrew = {
          enable = true;
          brews = [
            "code-server"
          ];
          casks = [
            "keyboardcleantool"
            "vivaldi"
          ];
          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
          };
        };

        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true;
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;

        fonts.packages = [
          pkgs.nerd-fonts.fira-code
        ];

        system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          finder.AppleShowAllExtensions = true;
          finder.FXPreferredViewStyle = "clmv";
          screencapture.location = "~/Pictures/screenshots";
          screensaver.askForPasswordDelay = 10;
        };

        nixpkgs = {
          hostPlatform = "aarch64-darwin";
          config.allowUnfree = true;
        };

        system.activationScripts.applications.text =
          let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            };
          in
          pkgs.lib.mkForce ''
            # Set up applications.
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read -r src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';
      };
    in
    {
      darwinConfigurations."Parvs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "parvgupta";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            users.users.parvgupta.home = "/Users/parvgupta";
            home-manager.users.parvgupta = import ./home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfiguration."Parvs-MacBook-Pro".pkgs;
    };
}
