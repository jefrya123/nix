{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop.nix
    ./modules/development.nix
    ./modules/gaming.nix
    ./modules/security.nix
  ];

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "quiet" "splash" "nvidia-drm.modeset=1" ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  # Networking
  networking = {
    hostName = "nixos-dev";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 3000 8000 8080 ];
      allowedUDPPorts = [ 53 67 68 ];
    };
  };

  # Time and locale
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Hardware acceleration
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # System utilities
    wget
    curl
    git
    htop
    tree
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
    
    # File management
    ranger
    nnn
    mc
    xfce.thunar
    
    # Network tools
    nmap
    wireshark
    speedtest-cli
    
    # Media
    mpv
    vlc
    ffmpeg
    
    # Development tools
    gcc
    gnumake
    cmake
    pkg-config
    python3
    nodejs
    yarn
    rustup
    go
    jdk
    maven
    gradle
    
    # Version control
    git-crypt
    git-lfs
    tig
    
    # Containers
    docker
    docker-compose
    podman
    
    # Monitoring
    iotop
    iftop
    nethogs
    btop
    
    # Security
    gnupg
    pass
    openssl
    
    # Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    jetbrains-mono
    source-code-pro
    ubuntu_font_family
  ];

  # Fonts
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      source-code-pro
      ubuntu_font_family
      material-design-icons
      material-icons
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" "Fira Code" "Source Code Pro" ];
        sansSerif = [ "Noto Sans" "Ubuntu" ];
        serif = [ "Noto Serif" "Liberation Serif" ];
      };
    };
  };

  # Services
  services = {
    # SSH
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # Printing
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Bluetooth
    blueman.enable = true;

    # Power management
    power-profiles-daemon.enable = true;

    # GNOME keyring
    gnome.gnome-keyring.enable = true;

    # Flatpak
    flatpak.enable = true;

    # Fwupd for firmware updates
    fwupd.enable = true;

    # Syncthing for file sync
    syncthing = {
      enable = true;
      user = "dev";
      dataDir = "/home/dev/Sync";
      configDir = "/home/dev/.config/syncthing";
    };

    # Tailscale for VPN
    tailscale.enable = true;

    # Docker
    docker.enable = true;

    # Postgres for development
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "init.sql" ''
        CREATE USER dev WITH SUPERUSER PASSWORD 'dev';
        CREATE DATABASE dev OWNER dev;
      '';
    };

    # Redis for development
    redis.enable = true;

    # Nginx for development
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."localhost" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  # Users
  users.users.dev = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" "input" "plugdev" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
    ];
  };

  # Programs
  programs = {
    # Zsh
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
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
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
      };
    };

    # Git
    git = {
      enable = true;
      config = {
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
      };
    };

    # SSH
    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
          UseKeychain yes
          IdentityFile ~/.ssh/id_ed25519
      '';
    };

    # GPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Dconf
    dconf.enable = true;

    # Steam
    steam = {
      enable = false; # Disabled as requested
    };

    # Wireshark
    wireshark.enable = true;

    # Java
    java.enable = true;
  };

  # System settings
  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };

  # Nix settings
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "dev" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Environment variables
  environment.variables = {
    EDITOR = "cursor";
    VISUAL = "cursor";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    SHELL = "/run/current-system/sw/bin/zsh";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    GTK_THEME = "Adwaita-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
} 