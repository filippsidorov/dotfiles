{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sidorov.filipp3";
  home.homeDirectory = "/home/sidorov.filipp3";

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


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello
    coreutils
    hack-font
    telegram-desktop
    flameshot
    strace
    wl-clipboard 
    nextcloud-client
    libreoffice


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

  

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/yandex-disk/config.cfg".source = ~/dotfiles/yandex-disk/config.cfg;
    "Org".source = config.lib.file.mkOutOfStoreSymlink ~/Yandex.Disk/Org;
    ".emacs".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/emacs/.emacs;
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink ~/Yandex.Disk/.emacs.d;
    "home.nix".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/home.nix;

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


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
