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
            ansible
            argo
            argocd
            asdf-vm
            atmos
            azure-cli
            bashly
            direnv
            dive
            git
            gh
            gh-dash
            ghq
            gnugrep
            helix
            home-manager
            hwatch
            jnv
            just
            jq
            jqp
            k3d
            krew
            kubelogin
            lazygit
            legitify
            mkalias
            mise
            moreutils
            nixpkgs-fmt
            notify
            obsidian
            oh-my-posh
            pre-commit
            runme
            safe
            scorecard
            slack
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
            updatecli
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
            "localstack/tap/localstack-cli"
            "helm"
            "helm-docs"
            "mysql"
            "starship"
            "uv"
            "watch"
          ];
          casks = [
            "docker"
            "discord"
            "displaylink"
            "flux"
            "ghostty"
            "keyboardcleantool"
            # "ollama"
            "syncthing"
            "ticktick"
            "tunnelblick"
          ];
          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
          };
        };

        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";
        nix.package = pkgs.nix;
        nix.gc.automatic = true;
        nix.optimise.automatic = true;
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
          dock.persistent-apps = [
            "/Applications/Safari.app"
            "${pkgs.vscode}/Applications/Visual Studio Code.app"
            "${pkgs.slack}/Applications/Slack.app"
            "/Applications/Microsoft Teams.app"
            "/Applications/Zen Browser.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
          ];
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
      darwinConfigurations."DEBERL000009-2" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "parv.gupta";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            users.users."parv.gupta".home = "/Users/parv.gupta";
            home-manager.users."parv.gupta" = import ./home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfiguration."DEBERL000009-2".pkgs;
    };
}
