{ lib, ... }:
{
  imports = [
    ./editor.nix
    ./git.nix
    ./terminal.nix
    ./tools.nix
  ];

  editor.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  terminal.enable = lib.mkDefault true;
  tools.enable = lib.mkDefault false;
}
