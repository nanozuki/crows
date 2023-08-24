{ config, pkgs, spkgs, ... }:

{
  imports = [
    ./parts/terminal.nix
    ./parts/neovim.nix
    ./parts/languages.nix
    ./parts/working.private.nix
  ];
  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "crows";
    home.homeDirectory = "/Users/crows";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = 
      (with pkgs; [
        # go repo's generate
        (python3.withPackages
          (ps: with ps; [
            pyyaml
          ]))
        # grpc
        protobuf
        protoc-gen-go
        protoc-gen-go-grpc
        protoc-gen-validate
        gnostic # protoc-gen-openapi
        awscli2
        mycli
        wire
      ]) ++ (with spkgs; [
        atlas
        go-swagger_0_25_0
        kratos
        kratos-protoc-gen-go-http
        kratos-protoc-gen-go-errors
      ]);

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

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/crows/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}

