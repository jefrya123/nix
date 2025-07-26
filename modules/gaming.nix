{ config, pkgs, lib, ... }:

{
  # Gaming configuration - disabled by default as requested
  # Enable this module if you want gaming support later
  
  # Steam is explicitly disabled
  programs.steam = {
    enable = false;
  };

  # Gaming-related packages (optional)
  environment.systemPackages = with pkgs; [
    # Game launchers (optional)
    # lutris
    # heroic
    # minigalaxy
    
    # Game development tools
    godot
    godot-headless
    godot-server
    
    # Game emulators (optional)
    # retroarch
    # dolphin-emu
    # pcsx2
    # rpcs3
    
    # Gaming utilities
    gamemode
    mangohud
    goverlay
    
    # Input devices
    piper # For gaming mice
    libratbag # For gaming mice
    
    # Audio for gaming
    # pulseaudio-ctl # If not using pipewire
  ];

  # Gaming services
  services = {
    # GameMode for performance optimization
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        cpu = {
          governor = "performance";
          ioprio = 0;
        };
        gpu = {
          apply_gpu_optimisations = 1;
          gpu_memory_freq = 0;
        };
        custom = {
          start = "";
          end = "";
        };
      };
    };
  };

  # Gaming environment variables
  environment.variables = {
    # Vulkan
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
    
    # Mesa
    MESA_GL_VERSION_OVERRIDE = "4.6";
    MESA_GLSL_VERSION_OVERRIDE = "460";
    
    # Wine
    WINEDEBUG = "-all";
    WINEPREFIX = "$HOME/.wine";
    
    # GameMode
    LD_PRELOAD = "libgamemode.so.0";
  };

  # Gaming hardware support
  hardware = {
    # Game controllers
    xboxdrv.enable = false; # Enable if you have Xbox controllers
    
    # Gaming mice
    libratbag.enable = true;
    
    # Audio for gaming
    pulseaudio.enable = false; # Using pipewire instead
  };

  # Gaming security
  security = {
    # Allow gaming applications to work properly
    wrappers = {
      # Allow games to bind to network ports
      game = {
        source = "${pkgs.bash}/bin/bash";
        capabilities = "cap_net_bind_service+ep";
      };
    };
  };

  # Gaming programs
  programs = {
    # Wine for Windows games
    wine = {
      enable = true;
      package = pkgs.wineWowPackages.staging;
    };
    
    # GameMode
    gamemode.enable = true;
  };
} 