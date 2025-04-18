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
      deno # superior js runtime
      rustup
      taplo
      # cli/tui tools
      docker
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
  };
}
