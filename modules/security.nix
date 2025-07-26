{ config, pkgs, lib, ... }:

{
  # Security configuration
  security = {
    # AppArmor for application sandboxing
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    # Audit for system monitoring
    auditd.enable = true;

    # PAM configuration
    pam = {
      enableSSHAgentAuth = true;
      services = {
        login.enableGnomeKeyring = true;
        sudo.enableGnomeKeyring = true;
      };
    };

    # Sudo configuration
    sudo = {
      enable = true;
      wheelNeedsPassword = false; # For development convenience
      extraConfig = ''
        Defaults timestamp_timeout=30
        Defaults passwd_timeout=0
        Defaults lecture=never
      '';
    };

    # UFW firewall (alternative to nftables)
    ufw = {
      enable = false; # Using nftables instead
    };

    # Polkit for privilege escalation
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    # RTKit for real-time scheduling
    rtkit.enable = true;

    # Wrappers for security
    wrappers = {
      # Allow specific programs to bind to privileged ports
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

  # Security packages
  environment.systemPackages = with pkgs; [
    # Security tools
    gnupg
    pass
    age
    sops
    openssl
    nmap
    wireshark
    tcpdump
    netcat
    socat
    curl
    wget
    httpie
    
    # Password managers
    bitwarden
    keepassxc
    
    # Encryption tools
    cryptsetup
    veracrypt
    
    # Network security
    openvpn
    wireguard-tools
    tailscale
    
    # Security auditing
    lynis
    chkrootkit
    rkhunter
    
    # File integrity
    aide
    tripwire
    
    # Malware scanning
    clamav
    clamav-daemon
    
    # System hardening
    apparmor-utils
    audit
    audit-viewer
    
    # Key management
    sshfs
    sshuttle
    
    # Network monitoring
    iftop
    nethogs
    bandwhich
    bottom
    
    # Process monitoring
    htop
    btop
    procs
    strace
    ltrace
    
    # File system security
    fscrypt
    ecryptfs
    
    # Container security
    podman
    buildah
    skopeo
    dive
    
    # Kubernetes security
    kubectl
    k9s
    helm
    trivy
    
    # Cloud security
    awscli2
    azure-cli
    gcloud
    terraform
    terragrunt
    
    # Development security
    git-crypt
    git-secrets
    pre-commit
    
    # Code security
    bandit
    safety
    npm-audit
    cargo-audit
    govulncheck
  ];

  # Security services
  services = {
    # ClamAV for malware scanning
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };

    # Fail2ban for intrusion prevention
    fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = 3600;
      findtime = 600;
      jails = {
        sshd = ''
          enabled = true
          port = ssh
          filter = sshd
          logpath = /var/log/auth.log
          maxretry = 3
        '';
        nginx-http-auth = ''
          enabled = true
          port = http,https
          filter = nginx-http-auth
          logpath = /var/log/nginx/error.log
          maxretry = 3
        '';
      };
    };

    # SSH hardening
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PubkeyAuthentication = true;
        AuthorizedKeysFile = ".ssh/authorized_keys";
        ChallengeResponseAuthentication = false;
        UsePAM = true;
        X11Forwarding = false;
        AllowTcpForwarding = false;
        AllowAgentForwarding = false;
        PermitTunnel = false;
        MaxAuthTries = 3;
        MaxSessions = 10;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 0;
        LogLevel = "VERBOSE";
      };
      extraConfig = ''
        # Additional security settings
        Protocol 2
        HostKey /etc/ssh/ssh_host_rsa_key
        HostKey /etc/ssh/ssh_host_ecdsa_key
        HostKey /etc/ssh/ssh_host_ed25519_key
        KeyRegenerationInterval 3600
        ServerKeyBits 1024
        SyslogFacility AUTH
        LoginGraceTime 120
        StrictModes yes
        RSAAuthentication yes
        PubkeyAuthentication yes
        IgnoreRhosts yes
        RhostsRSAAuthentication no
        HostbasedAuthentication no
        PermitEmptyPasswords no
        ChallengeResponseAuthentication no
        PasswordAuthentication no
        X11Forwarding no
        X11DisplayOffset 10
        PrintMotd no
        PrintLastLog yes
        TCPKeepAlive yes
        AcceptEnv LANG LC_*
        Subsystem sftp /usr/lib/openssh/sftp-server
        UsePAM yes
      '';
    };

    # Network security
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;
            
            # Allow established connections
            ct state established,related accept
            
            # Allow loopback
            iif lo accept
            
            # Allow ICMP
            icmp type echo-request accept
            icmpv6 type echo-request accept
            
            # Allow SSH
            tcp dport 22 accept
            
            # Allow HTTP/HTTPS
            tcp dport { 80, 443 } accept
            
            # Allow development ports
            tcp dport { 3000, 8000, 8080 } accept
            
            # Allow DNS
            udp dport 53 accept
            
            # Allow DHCP
            udp dport { 67, 68 } accept
            
            # Log rejected packets
            log prefix "nftables rejected: "
          }
          
          chain forward {
            type filter hook forward priority 0; policy drop;
            ct state established,related accept
          }
          
          chain output {
            type filter hook output priority 0; policy accept;
          }
        }
      '';
    };

    # System monitoring
    prometheus = {
      enable = false; # Enable if you want metrics
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" "cpu" "diskstats" "filesystem" "loadavg" "meminfo" "netdev" "netstat" "textfile" "time" "vmstat" "logind" "interrupts" "ksmd" ];
        };
      };
    };

    # Logging
    rsyslogd.enable = true;
    journald.extraConfig = ''
      SystemMaxUse=1G
      SystemKeepFree=1G
      SystemMaxFileSize=100M
    '';
  };

  # Security environment variables
  environment.variables = {
    # Security-related environment variables
    GNUPGHOME = "$HOME/.gnupg";
    GPG_TTY = "$(tty)";
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    
    # Development security
    GIT_CRYPT_KEY = "$HOME/.git-crypt-key";
    SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
    
    # Container security
    DOCKER_CONTENT_TRUST = "1";
    DOCKER_BUILDKIT = "1";
    
    # Network security
    CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_DIR = "/etc/ssl/certs";
  };

  # Security programs
  programs = {
    # GPG configuration
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = 3600;
        max-cache-ttl = 7200;
        default-cache-ttl-ssh = 3600;
        max-cache-ttl-ssh = 7200;
      };
    };

    # SSH configuration
    ssh = {
      enable = true;
      extraConfig = ''
        # Security settings
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
          
        # Host-specific configurations
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

    # Firewall configuration
    firejail = {
      enable = true;
      wrappedBinaries = {
        firefox = "firefox";
        chromium = "chromium";
        brave = "brave";
        slack = "slack";
        discord = "discord";
        spotify = "spotify";
      };
    };
  };

  # Security boot configuration
  boot = {
    kernelParams = [
      "security=apparmor"
      "apparmor=1"
      "security=1"
      "selinux=0"
      "audit=1"
      "audit_backlog_limit=8192"
    ];
    
    kernel.sysctl = {
      # Network security
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.default.log_martians" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_max_syn_backlog" = 2048;
      "net.ipv4.tcp_synack_retries" = 2;
      "net.ipv4.tcp_syn_retries" = 5;
      
      # Memory protection
      "vm.mmap_min_addr" = 65536;
      "kernel.randomize_va_space" = 2;
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.unprivileged_bpf_disabled" = 1;
      
      # File system security
      "fs.suid_dumpable" = 0;
      "kernel.core_uses_pid" = 1;
      "kernel.core_pattern" = "|/bin/false";
      
      # Process security
      "kernel.yama.ptrace_scope" = 1;
      "kernel.perf_event_paranoid" = 2;
    };
  };
} 