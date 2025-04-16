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
      # langs
      clang
      deno # superior js runtime
      jdk
      nodejs # lame js runtime
      python3
      rustup
      # language servers
      bash-language-server
      fish-lsp
      pyright
      jdt-language-server
      vscode-langservers-extracted
      taplo
      # formatters
      prettierd
      ruff
      shfmt
      # whatever manager for whatever lang
      uv
      # cli/tui tools
      docker
      just
    ];
  };
}
