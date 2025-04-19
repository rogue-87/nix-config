{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    terminal.enable = lib.mkEnableOption "Installs preferred terminal + some other related stuff";
  };
  config = lib.mkIf config.terminal.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting";
    };

    programs.fastfetch = {
      enable = true;
    };

    programs.kitty = {
      enable = true;
      settings = {
        disable_ligatures = "never";
        enable_audio_bell = "no";
        shell = "fish";
        # font
        font_family = "JetBrainsMono Nerd Font";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = "14";
        # tab
        tab_bar_edge = "bottom";
        tab_bar_margin_height = 0;
        tab_bar_margin_width = 0;
        tab_bar_min_tabs = 2;
        tab_bar_style = "separator";
        tab_separator = "\"   ┇   \"";
        tab_title_max_length = 10;
        tab_switch_strategy = "previous";
        # window
        draw_minimal_borders = "yes";
        placement_strategy = "center";
        single_window_margin_width = -1;
        single_window_padding_width = -1;
        window_border_width = "1pt";
        window_margin_width = 0;
        window_padding_width = 0;
      };
      themeFile = "GitHub_Dark";
    };

    programs.lf.enable = true;

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
