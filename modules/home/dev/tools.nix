{
  pkgs,
  lib,
  config,
  rust-overlay,
  ...
}:
{
  options = {
    tools.enable = lib.mkEnableOption "installs some dev stuff";
  };
  config = lib.mkIf config.tools.enable {

    nixpkgs.overlays = [ rust-overlay.overlays.default ];
    home.packages = with pkgs; [
      # stuff that I like to have available just in case
      lua5_1 # fav scripting language
      deno # superior js runtime
      vscode-langservers-extracted
      # global rust toolchain cuz of my unreliable internet :D
      rust-bin.stable.latest.default
      cargo-binstall
      rust-analyzer
      taplo
      # cli/tui tools
      btop
      direnv
      just
      lazygit
      luarocks
      tree-sitter
    ];

    home.sessionPath = [
      "/home/rogue/.cargo/bin"
    ];
  };
}
