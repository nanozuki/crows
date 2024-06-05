{ pkgs, self, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];
  environment.variables = {
    OBSIDIAN_REST_API_KEY = "55be947074fadb57abcdf1070d551d4f3718c43e9e9ee246901c7cdfb1b63f7d";
  };
  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "mas" # for Mac App Store
    ];
    casks = [
      "1password"
      "android-file-transfer"
      "calibre"
      "dbeaver-community"
      "deepl"
      "discord"
      "firefox"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-symbols-only-nerd-font"
      "fork"
      "google-chrome"
      "iina"
      "iterm2"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "kitty"
      "obsidian"
      "orbstack"
      "paw"
      "postman"
      "qbittorrent"
      "shottr"
      "squirrel"
      "steam"
      "syncthing"
      "tailscale"
      "telegram"
      "vimr"
      "visual-studio-code"
      "wezterm"
    ];
    masApps = {
      Things = 904280696;
      iStatMenus = 1319778037;
      Keka = 470158793;
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  # nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this ystem.
  nix.settings.experimental-features = "nix-command flakes";
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 10; Minute = 0; };
    options = "--delete-older-than 30d";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.activationScripts.postUserActivation.text = ''
    # activateSettings -u will reload the settings from the database and apply them to the current session,
    # so we do not need to logout and login again to make the changes take effect.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  # macOS's defaults configuration
  # system.defaults = {};
  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
