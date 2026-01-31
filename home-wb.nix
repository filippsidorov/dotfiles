# home-wb.nix

{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";



  # Simple autostart - runs your script on login
  xdg.configFile."autostart/setup-keybinding.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Setup Flameshot Keybinding
    Exec=${config.home.homeDirectory}/dotfiles/setup-gnome-keybindings.sh
    X-GNOME-Autostart-enabled=true
  '';

  programs.bash = {
    enable = true;
    enableCompletion = false;  # Disable to avoid 'have' errors
    shellAliases = {
      ls = "ls --color=auto";
    };
    bashrcExtra = ''
      # Load dircolors if available
      if command -v dircolors > /dev/null; then
        eval "$(dircolors)"
      fi
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.enableNixpkgsReleaseCheck = false;
  
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  systemd.user.services."gnome-terminal-dracula" = {
    Unit = {
      Description = "Apply Dracula theme to GNOME Terminal profile";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${config.xdg.configHome}/gnome-terminal-dracula.sh";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.file.".config/gnome-terminal-dracula.sh" = {
    text = ''
    #!/usr/bin/env bash
    set -e
    # your script body here (exactly what you pasted)
    echo "Configuring GNOME Terminal..."

    # Get the default profile UUID
    PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

    echo "Using profile: $PROFILE_UUID"

    # Dracula color palette
    DRACULA_PALETTE="['#21222c', '#ff5555', '#50fa7b', '#f1fa8c', '#bd93f9', '#ff79c6', '#8be9fd', '#f8f8f2', '#6272a4', '#ff6e6e', '#69ff94', '#ffffa5', '#d6acff', '#ff92df', '#a4ffff', '#ffffff']"
    DRACULA_BG='#282a36'
    DRACULA_FG='#f8f8f2'

    # Set font to Hack with size 14
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ use-system-font false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ font 'Hack 14'

    # Apply Dracula theme colors
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ background-color "$DRACULA_BG"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ foreground-color "$DRACULA_FG"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ palette "$DRACULA_PALETTE"

    # Optional: Enable bold colors
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ bold-color-same-as-fg true

    echo "✓ Font set to Hack 14"
    echo "✓ Dracula theme colors applied"
    echo "Configuration complete! Restart your terminal to see the changes."

   '';
    executable = true;
  };

  programs.emacs = {
    enable = false;

  };


  programs.autorandr = {
    enable = true;
    
    profiles = {
      "mobile" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff000e6f131400000000001e0104a51e137803c5f5a3554c9b230c4f5400000001010101010101010101010101010101353c80a070b02340302036002ebd10000018000000fd00303c4a4a0f010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e453030374a41312d320a2000ad
";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1200";
            position = "0x0";
            rate = "60.00";
          };
        };
      };
      
      "work" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff000e6f131400000000001e0104a51e137803c5f5a3554c9b230c4f5400000001010101010101010101010101010101353c80a070b02340302036002ebd10000018000000fd00303c4a4a0f010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e453030374a41312d320a2000ad
";
          DP-1 = "00ffffffffffff001e6d507782d6010001220104b5462878fa7ba1ae4f44a9260c5054210800d1c061400101010101010101010101014dd000a0f0703e8030203500b9882100001a000000fd00283c1e873c000a202020202020000000fc004c472048445220344b0a202020000000ff003430314e544456334a3435300a01ec02031f7223090707830100004401030410e2006ae305c000e606050159595204740030f2705a80b0588a00b9882100001e565e00a0a0a0295030203500b9882100001a1a3680a070381f402a263500b9882100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000ea
";
        };
        config = {
          DP-1 = {
            enable = true;
            primary = true;
            mode = "2560x1440";
            position = "0x0";
            rate = "60.00";
          };
          eDP-1 = {
            enable = true;
            mode = "1920x1200";
            primary = true;
            position = "0x1440";
            rate = "60.00";
          };
        };
      };
    };
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello  # Simple test program for Nix installation verification
    coreutils  # GNU core utilities (ls, cat, etc.)
    tree  # Directory tree visualization
    htop  # Interactive process viewer
    strace  # System call tracer for debugging
    hack-font  # Monospace font for coding
    telegram-desktop  # Telegram messaging client
    flameshot  # Screenshot tool with annotation
    libreoffice  # Office suite for documents/spreadsheets
    nextcloud-client  # Cloud storage sync client
    wl-clipboard  # Command-line clipboard utilities for Wayland (wl-copy/wl-paste)
    ollama  # Local LLM runner for AI models
    noisetorch  # Real-time noise suppression for microphone
    ghq # Remote repository management made easy
    dbeaver-bin
    focuswriter

    # Simple Emacs wrapper
    (writeShellScriptBin "emacs" ''
      exec ${emacs}/bin/emacs --user "" "$@"
    '')

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];



  # Ollama - Local LLM inference server
  # Runs as a systemd user service managed by home-manager
  # Provides OpenAI-compatible API on localhost:11434
  services.ollama = {
    enable = true;
    
    # Set environment variables for the systemd service
    environmentVariables = {
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_KEEP_ALIVE = "5m";
      OLLAMA_HOST = "0.0.0.0:11434";
      
      # Additional useful settings for network timeouts
      OLLAMA_NUM_PARALLEL = "4";
      OLLAMA_MAX_QUEUE = "512";
      
      # Optional: Set custom models directory
      # OLLAMA_MODELS = "/home/yourusername/.ollama/models";
    };
    
    # Optional: specify which models to load
    # models = [ "/path/to/model" ];
  };
 


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    "Org".source = config.lib.file.mkOutOfStoreSymlink ~/Yandex.Disk/Org;

    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink ~/Yandex.Disk/.emacs.d;

    "ghq".source = config.lib.file.mkOutOfStoreSymlink ~/Yandex.Disk/ghq;
    "home.nix".source = config.lib.file.mkOutOfStoreSymlink ~/ghq/github.com/filippsidorov/dotfiles/home-wb.nix;
    ".emacs".source = config.lib.file.mkOutOfStoreSymlink ~/ghq/github.com/filippsidorov/dotfiles/emacs/.emacs;
    "dotfiles".source = config.lib.file.mkOutOfStoreSymlink ~/ghq/github.com/filippsidorov/dotfiles;
    ".config/yandex-disk/config.cfg".source = ~/ghq/github.com/filippsidorov/dotfiles/yandex-disk/config.cfg;
    "FocusWriter".source = config.lib.file.mkOutOfStoreSymlink ~/Yandex.Disk/FocusWriter;
  };
  
  fonts.fontconfig.enable = true;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sidorov.filipp3/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    FLAMESHOT = "flameshot";
    HOME = "/home/sidorov.filipp3";
    XDG_CONFIG_HOME = "$HOME/.config";
  };


  services.autorandr = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
