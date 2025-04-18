{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    tools.enable = lib.mkEnableOption "installs compilers/runtimes, language servers, formatters, linters and other tools";
  };
  config = lib.mkIf config.tools.enable {
    home.packages = with pkgs; [
      # stuff that I like to have available just in case
      lua # fav scripting language
      deno # superior js runtime
      rustc
      rustfmt
      rust-analyzer
      cargo
      cargo-binstall
      clippy
      taplo
      pkg-config
      openssl
      # cli/tui tools
      just
      lazygit
      btop
      direnv
      # stuff that should be managed by shell.nix or flake.nix
      # in a local project
      /*
        clang
        jdk
        nodejs # lame js runtime
        python3
        # language servers
        pyright
        jdt-language-server
        vscode-langservers-extracted
        # formatters
        ruff
        # other
        uv
      */
    ];

    home.sessionPath = [
      "/home/rogue/.cargo/bin"
    ];
  };
}
