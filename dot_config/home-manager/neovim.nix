{ pkgs, ... }:
{
  imports = [
    ./langs/go.nix
    ./langs/rust.nix
    ./langs/node.nix
    ./langs/others.nix
  ];

  home.packages = with pkgs; [
    # tools
    ripgrep
    fzf

    # config and markup languages 
    ## nix
    nil
    nixpkgs-fmt
    ## lua
    lua-language-server
    stylua
    ## vim 
    nodePackages.vim-language-server
    ## json, yaml
    vscode-langservers-extracted # include {html,css,json,eslint}-language-server
    nodePackages.yaml-language-server
    nodePackages.prettier
  ];

  programs.neovim = {
    enable = true;
    withPython3 = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
