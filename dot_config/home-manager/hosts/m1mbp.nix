{ pkgs, ... }:

{
  imports = [
    ./parts/terminal.nix
    ./parts/neovim.nix
    ./parts/languages.nix
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";

    home.stateVersion = "23.05"; # Please read the comment before changing.

    home.packages = [
      pkgs.ffmpeg
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
