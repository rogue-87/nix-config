{ lib, ... }:
{
  imports = [
    ./docker.nix
    ./steam.nix
  ];

  docker.enable = lib.mkDefault false;
  steam.enable = lib.mkDefault false;
}
