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
    # fav code editor
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = with pkgs; [
        # nix stuff
        nixd
        nixfmt-rfc-style
        # lua stuff
        lua-language-server
        luajit
        luarocks
        selene
        stylua
        # other stuff(shell scripting, note taking, etc...)
        tinymist
        typst
        marksman
        prettierd
        bash-language-server
        shfmt
        fish-lsp
        # stuff that nvim plugins may use
        tree-sitter
        btop
        lazygit
        fd
        ripgrep
      ];
      withNodeJs = true;
      withPython3 = true;
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

    home.file.".config/nvim" = {
      # you might be asking... WHY?
      # well it's because of lazy.nvim lazy-lock.json file
      # also I don't want to run "home-manager switch" every single time I change something in my nvim config
      # this pretty much tells home-manager not to put the symlink in the store
      # just symlink it directly to the nvim config located in dotfiles/ somewhere in home dir
      # however do keep in mind there are several symlinks standing between this config and the symlink in ~/.config/nvim
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/profiles/laptop/nvim/.config/nvim";
    };
  };
}
