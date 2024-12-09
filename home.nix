{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "parvgupta";
    homeDirectory = "/Users/parvgupta";
    stateVersion = "24.11";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/.config/nix";
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile configs/oh-my-posh.toml));
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
    extensions = (with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      foxundermoon.shell-format
      timonwong.shellcheck
      mads-hartmann.bash-ide-vscode
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "lazygit-vscode";
        publisher = "tompollak";
        version = "0.1.10";
        sha256 = "jtupi/M0yQKBNABWglnoJp54P7OM0bGLWjsxbL15Va8=";
      }
      {
        # Runme Notebooks for DevOps
        name = "runme";
        publisher = "stateful";
        version = "3.10.3";
        sha256 = "BkYT9SiziFW97yqU+1lwL5sVK1JQIivFr63eIbDjjhA=";
      }
      {
        name = "output-colorizer";
        publisher = "IBM";
        version = "0.1.2";
        sha256 = "Z22nS9dW1w7L9taO3PkxzQA9tOqsPjQPY17ZMam9M0U=";
      }
      {
        name = "supermaven";
        publisher = "supermaven";
        version = "1.1.12";
        sha256 = "/fZungx+wdtKo80KCGZa4WfHMTT6Imb5MBgQ8gAGhfQ=";
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
      "breadcrumbs.enabled" = false;
      "git.enabled" = false;
      "telemetry.telemetryLevel" = "off";
      "update.showReleaseNotes" = false;
      "workbench.sideBar.location" = "right";
      "zenMode.centerLayout" = false;
      "[shellscript]" = {
        "editor.defaultFormatter" = "foxundermoon.shell-format";
      };
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
}
