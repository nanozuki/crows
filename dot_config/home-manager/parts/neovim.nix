{ pkgs, ... }:
{
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

    # other editors
    helix
  ];

  programs.neovim = {
    enable = true;
    withPython3 = true;
    withNodeJs = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
