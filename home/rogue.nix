{ pkgs, ... }:
{
  imports = [
    ./../modules/home/dev
    ./../modules/home/games.nix
  ];

  # modules
  editor.enable = true;
  git.enable = true;
  terminal.enable = true;
  tools.enable = true;
  games.enable = true;

  home.username = "rogue";
  home.homeDirectory = "/home/rogue";
  home.sessionVariables = {
    CHROMIUM_EXECUTABLE = "chromium-browser";
  };

  home.packages = with pkgs; [
    discord
    youtube-music
    syncthing
    # fonts
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # WARN: read home-manager change-logs before editing
  home.stateVersion = "24.11";
}
