{ lib, ... }:
{
  imports = [
    ./git.nix
    ./editor.nix
    ./tools.nix
  ];

  git.enable = lib.mkDefault true;
  editor.enable = lib.mkDefault true;
  tools.enable = lib.mkDefault false;
}
