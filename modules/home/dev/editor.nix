{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    editor.enable = lib.mkEnableOption "installs and configures neovim with a bunch of other tools";
  };

  config = lib.mkIf config.editor.enable {
    home.packages = with pkgs; [
      btop
      lazygit

      nixd
      nixfmt-rfc-style

      lua
      lua-language-server
      luarocks
      tree-sitter
      selene
      stylua
      # language servers for taking notes
      marksman
      tinymist
    ];

    # fav code editor
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    # gui fronted for my fav code editor
    programs.neovide = {
      enable = true;
      settings = {
        fork = false;
        frame = "none";
        idle = true;
        maximized = true;
        mouse-cursor-icon = "arrow";
        # neovim-bin = "/usr/bin/nvim";
        no-multigrid = false;
        srgb = false;
        tabs = false;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;

        font = {
          normal = [ "JetBrainsMono Nerd Font" ];
          size = 14.0;
        };
        box-drawing = {
          mode = "font-glyph";
        };
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.file = {
      ".config/nvim".source = ./../../../dotfiles/nvim;
    };
  };
}
