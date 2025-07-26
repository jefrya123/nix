{ config, lib, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./terminal.nix
    ./applications.nix
  ];

  home = {
    username = "dev";
    homeDirectory = "/home/dev";
    stateVersion = "23.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "cursor";
    VISUAL = "cursor";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    SHELL = "/run/current-system/sw/bin/zsh";
    
    # Development
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    NODE_PATH = "$HOME/.npm-global/lib/node_modules";
    
    # X11 (Plasma)
    XDG_SESSION_TYPE = "x11";
    QT_QPA_PLATFORM = "xcb";
  };

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
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = "adwaita-dark";
  };

  # Programs
  programs = {
    # Git
    git = {
      enable = true;
      userName = "Developer";
      userEmail = "dev@example.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core.editor = "cursor";
        core.autocrlf = "input";
        color.ui = "auto";
        alias.st = "status";
        alias.co = "checkout";
        alias.br = "branch";
        alias.ci = "commit";
        alias.cm = "commit -m";
        alias.amend = "commit --amend";
        alias.unstage = "reset HEAD --";
        alias.last = "log -1 HEAD";
        alias.visual = "!gitk";
        alias.graph = "log --graph --oneline --all";
        alias.lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };

    # Zsh
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      history = {
        size = 10000;
        save = 10000;
        path = "$HOME/.zsh_history";
      };
      shellAliases = {
        # Development
        dev = "cd ~/Development";
        proj = "cd ~/Projects";
        src = "cd ~/src";
        
        # Git
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git pull";
        gco = "git checkout";
        gcb = "git checkout -b";
        gb = "git branch";
        gd = "git diff";
        glog = "git log --oneline --graph";
        
        # Docker
        dc = "docker-compose";
        dps = "docker ps";
        dex = "docker exec -it";
        
        # Kubernetes
        k = "kubectl";
        kctx = "kubectx";
        kns = "kubens";
        
        # Development servers
        serve = "python3 -m http.server";
        dev-server = "npm run dev";
        api-server = "python3 -m uvicorn main:app --reload";
        
        # Database
        psql-dev = "psql -U dev -d dev";
        redis-cli = "redis-cli";
        
        # Utilities
        ll = "exa -l";
        la = "exa -la";
        lt = "exa -T";
        cat = "bat";
        grep = "rg";
        find = "fd";
        ps = "procs";
        top = "btop";
        du = "dust";
        df = "duf";
        ping = "gping";
        ls = "exa";
        tree = "exa -T";
        neofetch = "fastfetch";
        
        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
      };
      initExtra = ''
        # Oh My Zsh theme
        export ZSH_THEME="agnoster"
        
        # Custom prompt
        PROMPT='%F{blue}%n%f@%F{green}%m%f %F{yellow}%~%f %F{red}%(?..%?)%f %# '
        
        # History search
        bindkey '^R' history-incremental-search-backward
        
        # Better completion
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        
        # Development environment
        if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
          source ~/.nix-profile/etc/profile.d/nix.sh
        fi
        
        # Rust
        if [ -f ~/.cargo/env ]; then
          source ~/.cargo/env
        fi
        
        # Go
        export PATH=$PATH:$(go env GOPATH)/bin
        
        # Node.js
        export PATH=$PATH:$HOME/.npm-global/bin
        
        # Python
        export PATH=$PATH:$HOME/.local/bin
        
        # Welcome message
        echo "Welcome to your NixOS development environment!"
        echo "Type 'neofetch' for system info or 'fastfetch' for a faster version."
      '';
    };

    # SSH
    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
          UseKeychain yes
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
          ServerAliveInterval 300
          ServerAliveCountMax 3
          TCPKeepAlive yes
          Compression yes
          ControlMaster auto
          ControlPath ~/.ssh/control-%h-%p-%r
          ControlPersist 1h
          
        Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          
        Host gitlab.com
          HostName gitlab.com
          User git
          IdentityFile ~/.ssh/id_ed25519
      '';
    };

    # GPG
    gpg = {
      enable = true;
      settings = {
        default-cache-ttl = 3600;
        max-cache-ttl = 7200;
        default-cache-ttl-ssh = 3600;
        max-cache-ttl-ssh = 7200;
      };
    };

    # FZF
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 40%" "--border" ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
    };

    # Bat
    bat = {
      enable = true;
      config = {
        theme = "Catppuccin-mocha";
        style = "numbers,changes,header";
        pager = "less -FR";
      };
    };

    # Exa
    exa = {
      enable = true;
      enableAliases = true;
    };

    # Bottom
    bottom = {
      enable = true;
      settings = {
        flags.group_processes = true;
        flags.tree = true;
        flags.mem_as_value = true;
        flags.temp_type = "c";
        colors.high_green = "#a6e3a1";
        colors.medium_green = "#89b4fa";
        colors.low_green = "#f5c2e7";
        colors.avg_cpu = "#f5c2e7";
        colors.cpu_core = "#cba6f7";
        colors.ram = "#a6e3a1";
        colors.swap = "#f38ba8";
        colors.disk_activity = "#f9e2af";
        colors.disk_free = "#a6e3a1";
        colors.disk_total = "#89b4fa";
        colors.disk_used = "#f5c2e7";
        colors.network_in = "#a6e3a1";
        colors.network_out = "#f38ba8";
        colors.network_local = "#89b4fa";
        colors.temp_low = "#a6e3a1";
        colors.temp_mid = "#f9e2af";
        colors.temp_high = "#f38ba8";
      };
    };
  };

  # Services
  services = {
    # SSH agent
    ssh-agent = {
      enable = true;
    };

    # GPG agent
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = [ "your-gpg-key-id-here" ];
    };

    # Syncthing
    syncthing = {
      enable = true;
      tray.enable = true;
    };

    # Network manager applet
    network-manager-applet.enable = true;

    # Bluetooth
    blueman-applet.enable = true;

    # GNOME keyring
    gnome-keyring = {
      enable = true;
      components = [ "secrets" "ssh" ];
    };
  };

  # XDG
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "cursor.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "image/*" = "imv.desktop";
        "video/*" = "mpv.desktop";
        "audio/*" = "mpv.desktop";
      };
    };
  };

  # System packages
  home.packages = with pkgs; [
    # Development tools
    cursor
    vscode
    jetbrains.idea-community
    jetbrains.pycharm-community
    jetbrains.webstorm
    
    # Communication
    slack
    discord
    telegram-desktop
    signal-desktop
    
    # Media
    spotify
    vlc
    mpv
    
    # Browsers
    firefox
    chromium
    brave
    
    # File managers
    nautilus
    dolphin
    pcmanfm
    
    # System tools
    gnome.gnome-tweaks
    gnome.gnome-software
    gnome.gnome-calculator
    gnome.gnome-screenshot
    gnome.gnome-disk-utility
    
    # Terminal emulators
    alacritty
    kitty
    wezterm
    
    # System monitoring
    gnome.gnome-system-monitor
    htop
    btop
    
    # Network tools
    networkmanagerapplet
    blueman
    
    # Audio
    pavucontrol
    helvum
    
    # Theme and icons
    papirus-icon-theme
    nordic
    catppuccin-gtk
    adw-gtk3
    catppuccin-cursors.mochaDark
    
    # Utilities
    wget
    curl
    git
    ripgrep
    fd
    bat
    exa
    fzf
    jq
    yq
    tmux
    neofetch
    onefetch
    fastfetch
    cmatrix
    sl
    fortune
    cowsay
    lolcat
  ];
} 