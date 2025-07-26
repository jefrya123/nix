{ config, pkgs, lib, ... }:

{
  # Development tools and languages
  environment.systemPackages = with pkgs; [
    # Core development tools
    gcc
    gnumake
    cmake
    pkg-config
    ninja
    meson
    
    # Languages and runtimes
    python3
    python3Packages.pip
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.virtualenv
    python3Packages.poetry
    
    nodejs
    yarn
    npm
    
    rustup
    cargo
    rustc
    
    go
    gopls
    
    jdk
    maven
    gradle
    sbt
    
    # Lisp and functional
    racket
    clojure
    haskell.compiler.ghc
    cabal-install
    stack
    
    # Scripting
    perl
    ruby
    php
    lua
    luajit
    
    # Database tools
    postgresql
    mysql80
    sqlite
    redis
    mongodb
    
    # Version control
    git
    git-crypt
    git-lfs
    tig
    gitAndTools.gitFull
    gitAndTools.delta
    gitAndTools.lazygit
    
    # Code editors and IDEs
    cursor
    vscode
    jetbrains.idea-community
    jetbrains.pycharm-community
    jetbrains.webstorm
    jetbrains.clion
    jetbrains.goland
    jetbrains.rider
    jetbrains.datagrip
    
    # Terminal and shell
    alacritty
    kitty
    wezterm
    tmux
    zsh
    oh-my-zsh
    
    # Development utilities
    ripgrep
    fd
    bat
    exa
    fzf
    jq
    yq
    htop
    btop
    procs
    dust
    duf
    gping
    bandwhich
    bottom
    
    # Container tools
    docker
    docker-compose
    podman
    buildah
    skopeo
    
    # Kubernetes
    kubectl
    kubectx
    k9s
    helm
    minikube
    kind
    
    # Cloud tools
    awscli2
    azure-cli
    gcloud
    terraform
    terragrunt
    
    # Monitoring and debugging
    strace
    ltrace
    gdb
    valgrind
    perf-tools
    flamegraph
    
    # Network tools
    nmap
    wireshark
    tcpdump
    netcat
    socat
    curl
    wget
    httpie
    
    # Security tools
    openssl
    gnupg
    pass
    age
    sops
    
    # Build tools
    bazel
    buck2
    pants
    
    # Documentation
    pandoc
    asciidoctor
    plantuml
    graphviz
    
    # Testing
    postman
    insomnia
    k6
    
    # Code quality
    shellcheck
    hadolint
    yamllint
    jsonlint
    prettier
    eslint
    black
    flake8
    rubocop
    clang-format
    rustfmt
    gofmt
    
    # LSP servers
    nil # Nix
    nixd # Nix
    rust-analyzer
    gopls
    clangd
    pyright
    typescript-language-server
    eslint-lsp
    html-lsp
    css-lsp
    json-lsp
    yaml-language-server
    docker-ls
    terraform-ls
    lua-language-server
    haskell-language-server
  ];

  # Development services
  services = {
    # Database services
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
        CREATE DATABASE test OWNER dev;
      '';
    };

    redis.enable = true;
    
    mysql = {
      enable = true;
      package = pkgs.mysql80;
      settings = {
        mysqld = {
          user = "mysql";
          port = 3306;
          bind-address = "127.0.0.1";
        };
      };
    };

    # Development servers
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "localhost" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
        "api.localhost" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8000";
          };
        };
      };
    };

    # Docker
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "weekly";
    };

    # Kubernetes
    kubernetes = {
      enable = false; # Enable if needed
      roles = [ "master" "node" ];
    };
  };

  # Development environment
  environment.variables = {
    # Language-specific
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";
    GOPATH = "$HOME/go";
    GOROOT = "${pkgs.go}/share/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    NODE_PATH = "$HOME/.npm-global/lib/node_modules";
    
    # Development tools
    EDITOR = "cursor";
    VISUAL = "cursor";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    
    # Database URLs
    DATABASE_URL = "postgresql://dev:dev@localhost:5432/dev";
    REDIS_URL = "redis://localhost:6379";
    
    # Development ports
    DEV_PORT = "3000";
    API_PORT = "8000";
    
    # Git
    GIT_AUTHOR_NAME = "Developer";
    GIT_AUTHOR_EMAIL = "dev@example.com";
    GIT_COMMITTER_NAME = "Developer";
    GIT_COMMITTER_EMAIL = "dev@example.com";
  };

  # Development programs
  programs = {
    # Git configuration
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
        alias.graph = "log --graph --oneline --all";
        alias.lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };

    # SSH for development
    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
          UseKeychain yes
          IdentityFile ~/.ssh/id_ed25519
          
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

    # GPG for signing commits
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Zsh for development
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        # Development aliases
        dev = "cd ~/Development";
        proj = "cd ~/Projects";
        src = "cd ~/src";
        
        # Git shortcuts
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
        
        # Docker shortcuts
        dc = "docker-compose";
        dps = "docker ps";
        dex = "docker exec -it";
        
        # Kubernetes shortcuts
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
      };
    };
  };

  # Development security
  security = {
    # Allow development tools to work properly
    wrappers = {
      # Allow non-root users to bind to privileged ports
      node = {
        source = "${pkgs.nodejs}/bin/node";
        capabilities = "cap_net_bind_service+ep";
      };
      python = {
        source = "${pkgs.python3}/bin/python";
        capabilities = "cap_net_bind_service+ep";
      };
    };
  };
} 