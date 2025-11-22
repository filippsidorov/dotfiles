{ config, pkgs, lib, ... }:

let
  nixGL = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/nixGL/archive/main.tar.gz";
  }) {};
in
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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.enableNixpkgsReleaseCheck = false;


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.hello
    pkgs.coreutils
    pkgs.hack-font
    pkgs.telegram-desktop
    nixGL.nixGLIntel
    pkgs.flameshot
    pkgs.strace


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
    "/etc/gdm3/custom.conf".source = ~/dotfiles/gdm3/custom.conf;

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
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
