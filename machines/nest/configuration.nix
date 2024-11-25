# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      DEVICE partitions
      MAILADDR pt.wenhan@gmail.com
      ARRAY /dev/md1 metadata=1.2 name=homeport:raid6l32t UUID=b4ed8b7e:8b7a0ddc:6fb2682b:50286e95
    '';
  };
  # FileSystems
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/26fc66c6-9573-4d51-b1a6-8aa633101325";
    fsType = "xfs";
  };
  fileSystems."/disks/970" = {
    device = "/dev/disk/by-uuid/f000e6d2-bff4-422f-a96e-0f2b7083bfe8";
    fsType = "xfs";
  };
  fileSystems."/disks/raid6l32t" = {
    device = "/dev/disk/by-uuid/b732587d-2192-4873-b5df-b14efd4dbf71";
    fsType = "xfs";
  };
  zramSwap.enable = true;
  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = { General = { Experimental = true; }; };
  };
  # GPU and Drivers
  boot.initrd.kernelModules = [ "amdgpu" ];

  # networking.hostName = "homeport"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    hostName = "homeport";
    useDHCP = true;
    nameservers = [ "127.0.0.1:10053" ];
    firewall.enable = true;
    firewall.allowPing = true;
  };
  services.resolved = {
    enable = true;
    fallbackDns = [ "192.168.1.1" ];
  };
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = ./mihomo.config.yaml;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-rime ];
      waylandFrontend = true;
    };
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.openssh = {
    enable = true;
  };

  # samba configurations
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "allow insecure wide links" = "yes";
        "workgroup" = "CROWSGROUP";
        "server string" = "HomeportSMB";
        "server role" = "standalone server";
        "logging" = "systemd";
        "max log size" = "50";
        "security" = "user";
      };
      share = {
        comment = "Homeport Share";
        path = "/disks/970/share";
        browseable = "yes";
        writable = "yes";
        "follow symlinks" = "yes";
        "wide links" = "yes";
      };
      nas = {
        comment = "Homeport Share";
        path = "/home/crows/Data";
        browseable = "yes";
        writable = "yes";
        "follow symlinks" = "yes";
        "wide links" = "yes";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crows = {
    isNormalUser = true;
    description = "crows";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kitty
      telegram-desktop
      wezterm
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "crows" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker-compose
    fastfetch
    gcc
    git
    gnumake
    google-chrome
    neovim
    obsidian
    pinentry-qt
  ];
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
  fonts.fontDir.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;

  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.syncthing = {
    enable = true;
    relay.enable = true;
    user = "crows";
    configDir = "/home/crows/.config/syncthing";
    settings = {
      options = {
        localAnnounceEnabled = true;
        localAnnouncePort = 8384;
      };
      devices = {
        raven = { id = "ZHC6K6C-EYPF7T4-QBJ2A7L-6STSA6A-WX65ANE-XVOHHWZ-POFJKEP-YBWTBAJ"; };
        pica = { id = "242PIDE-35ZL7BR-L7ICJDQ-EBGCGUU-ZOQHJPK-O5SFAPK-7USWJO3-RBNBFAQ"; };
      };
      folders = {
        iCloud = {
          path = "/home/crows/Documents/iCloud";
          devices = [ "raven" "pica" ];
        };
        obsidian = {
          path = "/home/crows/Documents/Obsidian";
          devices = [ "raven" "pica" ];
        };
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
