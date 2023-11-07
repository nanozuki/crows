{ config, pkgs, ... }: {
  home.packages = [
    pkgs.starship
  ];
  home.file.starship = {
    enable = true;
    source = ../configs/starship/config.toml;
    target = "${config.xdg.configHome}/starship/starship.toml";
  };
  home.file.starship_fish = {
    enable = true;
    text = ''
      # starship
      set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
      starship init fish | source
    '';
    target = "${config.xdg.configHome}/fish/after/starship.fish";
  };
}
