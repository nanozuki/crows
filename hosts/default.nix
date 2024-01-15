{
  pica = {
    homeConfig = ./pica.nix;
    system = "aarch64-darwin";
    vars = {
      font = {
        family = "JetBrains Mono NL";
        size = 14;
      };
      theme = {
        name = "rose-pine";
        variant = "dawn";
      };
    };
  };
  raven = {
    homeConfig = ./raven.nix;
    system = "aarch64-darwin";
    vars = {
      font = {
        family = "JetBrains Mono NL";
        size = 14;
      };
      theme = {
        name = "rose-pine";
        variant = "dawn";
      };
    };
  };
  nest = {
    homeConfig = ./nest.nix;
    system = "x86_64-linux";
    vars = {
      font = {
        family = "JetBrains Mono NL";
        size = 12;
      };
      theme = {
        name = "rose-pine";
        variant = "dawn";
      };
    };
  };
}
