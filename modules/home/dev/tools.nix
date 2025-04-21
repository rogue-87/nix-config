{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    tools.enable = lib.mkEnableOption "installs some dev stuff";
  };
  config = lib.mkIf config.tools.enable {
    home.packages = with pkgs; [
      # stuff that I like to have available just in case
      lua # fav scripting language
      deno # superior js runtime
      # global rust toolchain
      cargo
      cargo-binstall
      clippy
      rust-analyzer
      rustc
      rustfmt
      taplo
      # cli/tui tools
      just
      lazygit
      btop
      direnv
    ];

    home.sessionPath = [
      "/home/rogue/.cargo/bin"
    ];
  };
}
