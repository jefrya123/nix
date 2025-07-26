{ config, lib, pkgs, ... }:

{
  # Essential applications
  home.packages = with pkgs; [
    # IDE
    cursor
    
    # Communication
    slack
    discord
    telegram-desktop
    
    # Media
    spotify
    
    # Browser
    firefox
    
    # File manager
    dolphin
    
    # System tools
    plasma5Packages.systemsettings
    plasma5Packages.kcalc
    plasma5Packages.spectacle
    
    # Terminal
    alacritty
    
    # Development tools
    git
    ripgrep
    fd
    bat
    exa
    fzf
    jq
    tmux
    
    # Fun stuff
    neofetch
    fastfetch
    cmatrix
    sl
    fortune
    cowsay
    lolcat
  ];

  # Default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "cursor.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
    };
  };
} 