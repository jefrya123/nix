{ config, pkgs, lib, ... }:

{
  # Desktop environment - KDE Plasma for a clean, modern experience
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };

  # Desktop applications
  environment.systemPackages = with pkgs; [
    # Desktop environment
    plasma5Packages.plasma-workspace
    plasma5Packages.kde-gtk-config
    plasma5Packages.kdeplasma-addons
    
    # File managers
    dolphin
    krusader
    
    # Browsers
    firefox
    chromium
    brave
    
    # Communication
    slack
    discord
    telegram-desktop
    signal-desktop
    
    # Media
    spotify
    vlc
    mpv
    obs-studio
    
    # Productivity
    libreoffice
    gimp
    inkscape
    krita
    
    # System tools
    plasma5Packages.systemsettings
    plasma5Packages.discoverage
    plasma5Packages.kcalc
    plasma5Packages.spectacle
    plasma5Packages.partitionmanager
    
    # Development tools
    cursor
    vscode
    jetbrains.idea-community
    jetbrains.pycharm-community
    jetbrains.webstorm
    jetbrains.clion
    jetbrains.goland
    
    # Terminal emulators
    alacritty
    kitty
    wezterm
    
    # System monitoring
    plasma5Packages.plasma-systemmonitor
    htop
    btop
    
    # Network tools
    plasma5Packages.plasma-nm
    plasma5Packages.bluedevil
    
    # Audio
    plasma5Packages.plasma-pa
    helvum
    
    # Theme and icons
    papirus-icon-theme
    nordic
    catppuccin-gtk
    adw-gtk3
  ];

  # GTK and Qt theming
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "compact";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = "adwaita-dark";
  };

  # Desktop services
  services = {
    # KDE services
    plasma5 = {
      enable = true;
      workspace = {
        enable = true;
        wallpapers = [ pkgs.plasma5Packages.plasma-workspace-wallpapers ];
      };
    };

    # Desktop notifications
    dbus.enable = true;
    
    # Bluetooth
    bluedevil.enable = true;
    
    # Network manager
    plasma-nm.enable = true;
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Printing
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  # XDG portal for better integration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config.common.default = "kde";
  };

  # Security
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Programs
  programs = {
    # Dconf for GNOME settings
    dconf.enable = true;
    
    # SSH agent
    ssh.startAgent = true;
    
    # GPG agent
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Environment variables for desktop
  environment.variables = {
    # X11 (Plasma)
    XDG_SESSION_TYPE = "x11";
    QT_QPA_PLATFORM = "xcb";
    
    # GTK
    GTK_THEME = "Catppuccin-Mocha-Compact-Blue-Dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    
    # Applications
    EDITOR = "cursor";
    VISUAL = "cursor";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
} 