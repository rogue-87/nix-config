{ lib, ... }:
{
  imports = [
    ./games.nix
    ./media.nix
    ./productivity.nix
    ./social.nix
  ];

  games.enable = lib.mkDefault true;
  media.enable = lib.mkDefault true;
  productivity.enable = lib.mkDefault true;
  social.enable = lib.mkDefault true;
}
