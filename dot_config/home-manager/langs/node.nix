{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodePackages.nodejs
    nodePackages.pnpm
    # language server
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages."@tailwindcss/language-server"
    # linter
    nodePackages.eslint
    nodePackages.eslint_d
    # formatter
    nodePackages.prettier
    # deno runtime
    deno
  ];
}
