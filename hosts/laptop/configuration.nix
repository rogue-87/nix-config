{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Africa/Tripoli";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AG";
    LC_IDENTIFICATION = "en_AG";
    LC_MEASUREMENT = "en_AG";
    LC_MONETARY = "en_AG";
    LC_NAME = "en_AG";
    LC_NUMERIC = "en_AG";
    LC_PAPER = "en_AG";
    LC_TELEPHONE = "en_AG";
    LC_TIME = "en_AG";
  };

  users.users.rogue = {
    isNormalUser = true;
    description = "Rogue";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      # general stuff
      discord
      youtube-music
			syncthing
			syncthingtray-minimal
			# heroic
			home-manager

      fish # fav shell
      neovim # fav code editor
      neovide # neovim gui frontend
      tree-sitter

      # langs
      lua
      nodejs # lame js runtime
      deno # superior js runtime
      python3
      jdk
      clang
      rustup
      taplo

      # language servers
      nixd # for nix

      bash-language-server
      fish-lsp

      lua-language-server
      pyright
      jdt-language-server

      svelte-language-server
      vscode-langservers-extracted # html, css, json, markdown?

      # for taking notes
      marksman
      tinymist

      # formatters
      prettierd
      nixfmt-rfc-style
      ruff
      shfmt
      stylua

      # linters
      selene

      # package managers
      luarocks

      # cli/tui tools
      btop
      gh
      gitoxide
      zoxide
      just
      lazygit
      stow
      zellij
      docker

      # terminal emulators
      kitty
      rio

      # fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.plasma-browser-integration
    chromium
    git
    fd
    gcc
    librewolf
    ripgrep
    speedtest-rs
    tree
    wget
    wl-clipboard
  ];

  # **services**
  # services.openssh.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    jack.enable = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # **hardware**
  hardware.bluetooth.enable = true;

  # **network**
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # the green devil that is nvidia
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # WARN: read "man configuration.nix" or "https://nixos.org/nixos/options.html"  before changing
  system.stateVersion = "24.11";
}
