{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "parv.gupta";
    homeDirectory = "/Users/parv.gupta";
    stateVersion = "24.11";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/ghq/github.com/gptparv/nix-darwin-config";
      cd = "z";
    };
    initExtra = ''
      export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"
      export PATH="$HOME/.krew/bin:$PATH"
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      azure = {
        disabled = false;
        symbol = "[󰠅 ](bold blue)";
        format = "on [$symbol($subscription)]($style) ";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Parv Gupta";
    userEmail = "85178397+gptparv@users.noreply.github.com";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      alias = {
        sync = "!git fetch origin && git merge origin/main";
        dash = "!gh-dash";
      };
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = (with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      foxundermoon.shell-format
      timonwong.shellcheck
      mads-hartmann.bash-ide-vscode
      hashicorp.terraform
      ms-python.python
      ms-toolsai.jupyter
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "lazygit-vscode";
        publisher = "tompollak";
        version = "0.1.12";
        sha256 = "MEJl9EIWKc/Gr7ECMrkNSY9md4JfA2BG/kY0RuykFBI=";
      }
      {
        # Runme Notebooks for DevOps
        name = "runme";
        publisher = "stateful";
        version = "3.11.1738099233";
        sha256 = "dr2Ue2/v3OxUQXqvBZieHNMk7hP2wF9VEPkH8uo5okE=";
      }
      {
        name = "catppuccin-vsc-icons";
        publisher = "Catppuccin";
        version = "1.17.0";
        sha256 = "CSAIDlZNrelBf891ztK4n9IaRdtXqpeXnI00hG0/nfA=";
      }
      {
        name = "catppuccin-vsc";
        publisher = "Catppuccin";
        version = "3.16.0";
        sha256 = "eZwi5qONiH+XVZj7u2cjJm+Liv1q07AEd8d4nXEQgLw=";
      }
    ]);

    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'FiraCode Nerd Font', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = false;
      "editor.minimap.enabled" = false;
      "terminal.integrated.fontFamily" = "'FiraCode Nerd Font', 'monospace', monospace";
      "files.trimTrailingWhitespace" = true;
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "files.autoSave" = "onFocusChange";
      "diffEditor.ignoreTrimWhitespace" = false;
      "telemetry.telemetryLevel" = "off";
      "update.showReleaseNotes" = false;
      "zenMode.centerLayout" = false;
      "[shellscript]" = {
        "editor.defaultFormatter" = "foxundermoon.shell-format";
      };
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
    };

    keybindings = [
      {
        "key" = "cmd+j";
        "command" = "workbench.action.terminal.focus";
      }
      {
        "key" = "cmd+j";
        "command" = "workbench.action.focusActiveEditorGroup";
        "when" = "terminalFocus";
      }
      {
        "key" = "cmd+shift+j";
        "command" = "workbench.action.terminal.toggleTerminal";
      }
      {
        "key" = "cmd+k j";
        "command" = "workbench.action.toggleMaximizedPanel";
      }
    ];
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile configs/mise.toml));
    # settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile configs/mise-settings.toml));
  };
}
