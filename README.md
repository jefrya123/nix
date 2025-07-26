# NixOS Developer Workstation

A clean, "riced out" NixOS configuration for developers with Cursor IDE, essential tools, and a beautiful desktop environment.

## Features

- **Clean Desktop**: Beautiful Catppuccin theme with dark mode
- **Cursor IDE**: Primary development environment
- **Essential Apps**: Slack, Discord, Spotify, Firefox
- **Great CLI Tools**: Modern replacements for classic Unix tools
- **Development Ready**: Git, Docker, databases, and more
- **No Steam**: Gaming disabled as requested

## Quick Start

1. **Clone this repository**:
   ```bash
   git clone <your-repo-url>
   cd nixos-workstation
   ```

2. **Generate hardware configuration** (if needed):
   ```bash
   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```

3. **Customize the configuration**:
   - Edit `hardware-configuration.nix` with your disk UUIDs
   - Update SSH keys in `configuration.nix`
   - Modify timezone in `configuration.nix`

4. **Install NixOS**:
   ```bash
   sudo nixos-rebuild switch
   ```

5. **Set up home-manager** (optional):
   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
   nix-channel --update
   nix-shell '<home-manager>' -A install
   home-manager switch
   ```

## What's Included

### Desktop Environment
- KDE Plasma with custom theming
- Catppuccin Mocha dark theme
- Papirus icons
- Clean, modern look

### Development Tools
- **Cursor IDE** - Primary editor
- **Git** - Version control with nice aliases
- **Docker** - Containerization
- **Databases** - PostgreSQL, Redis, MySQL
- **Languages** - Python, Node.js, Rust, Go, Java
- **CLI Tools** - ripgrep, fd, bat, exa, fzf

### Applications
- **Communication**: Slack, Discord, Telegram
- **Media**: Spotify, VLC, MPV
- **Browser**: Firefox
- **Terminal**: Alacritty with Catppuccin theme

### System Tools
- **Monitoring**: htop, btop, neofetch
- **Network**: NetworkManager, Bluetooth
- **Security**: SSH, GPG, firewall
- **Fun**: cmatrix, sl, fortune, cowsay

## Customization

### Adding Packages
Edit `configuration.nix` and add to `environment.systemPackages`:
```nix
environment.systemPackages = with pkgs; [
  your-package-here
];
```

### Changing Theme
Edit `modules/desktop.nix` to change the GTK theme:
```nix
gtk.theme.name = "Your-Theme-Name";
```

### Development Environment
Edit `modules/development.nix` to add/remove development tools.

## File Structure

```
nixos-workstation/
├── configuration.nix          # Main system configuration
├── hardware-configuration.nix # Hardware-specific settings
├── modules/
│   ├── desktop.nix           # Desktop environment
│   ├── development.nix       # Development tools
│   ├── gaming.nix           # Gaming (disabled)
│   └── security.nix         # Security settings
├── home/
│   ├── default.nix          # Home-manager config
│   ├── terminal.nix         # Terminal settings
│   └── applications.nix     # User applications
└── README.md                # This file
```

## Troubleshooting

### Common Issues

1. **Boot issues**: Check `hardware-configuration.nix` disk UUIDs
2. **Network issues**: Ensure NetworkManager is enabled
3. **Theme not applying**: Restart Plasma or log out/in
4. **Cursor not working**: Check if it's in the package list

### Useful Commands

```bash
# Check configuration
sudo nixos-rebuild dry-activate

# Update system
sudo nixos-rebuild switch --upgrade

# Rollback
sudo nixos-rebuild switch --rollback

# Garbage collection
sudo nix-collect-garbage -d
```

## Contributing

Feel free to customize this configuration for your needs! The modular structure makes it easy to add or remove components.

## License

This configuration is provided as-is for educational and personal use. 