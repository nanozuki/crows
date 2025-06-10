{ pkgs, self, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];
  # Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "tfenv"
      "libxml2"
    ];
    taps = [ ];
    casks = [
      "1password"
      "chatgpt"
      "firefox"
      "fork"
      "fork"
      "ghostty"
      "jetbrains-toolbox"
      "kitty"
      "microsoft-teams"
      "obsidian"
      "orbstack"
      "shottr"
      "telegram"
    ];
  };
  environment.variables = {
    TFENV_ARCH = "amd64";
    PKG_CONFIG_PATH = "/opt/homebrew/opt/libxml2/lib/pkgconfig";
    GCP_PROJECT_ID = "cinemo-pace";
    NEW_GCP_PROJECT_ID = "cinemo-pace";
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  # nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this ystem.
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 10; Minute = 0; };
      options = "--delete-older-than 30d";
    };
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
  system.stateVersion = 6;
  system.primaryUser = "wtang";
  system.activationScripts.reload-settings.text = ''
    # activateSettings -u will reload the settings from the database and apply them to the current session,
    # so we do not need to logout and login again to make the changes take effect.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  # macOS's defaults configuration
  # system.defaults = {};
  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
