{
  lib,
  config,
  ...
}:
{
  options = {
    docker.enable = lib.mkEnableOption "Installs and configures docker";
  };
  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "rogue" ];
    virtualisation.docker.storageDriver = "btrfs";
  };
}
