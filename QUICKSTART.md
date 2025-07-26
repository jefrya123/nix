# Quick Start Guide for CachyOS

## 🚀 Getting Started

Since you're on CachyOS (which is based on Arch Linux), you'll need to install NixOS first. Here's how to get everything set up:

### 1. Install NixOS

First, you'll need to install NixOS on your system. You can either:
- **Dual boot**: Install NixOS alongside CachyOS
- **Replace CachyOS**: Install NixOS as your main OS
- **Virtual machine**: Test the configuration in a VM first

### 2. Clone the Repository

Once you have NixOS installed:

```bash
# Clone this repository
git clone https://github.com/yourusername/nixos-workstation.git
cd nixos-workstation

# Make the setup script executable
chmod +x setup.sh
```

### 3. Run the Setup Script

```bash
# Run the automated setup
./setup.sh
```

The script will:
- Generate hardware configuration
- Copy configuration files
- Check for errors
- Apply the configuration
- Set up home-manager (optional)

### 4. Manual Setup (Alternative)

If you prefer to do it manually:

```bash
# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# Copy configuration files
sudo cp configuration.nix /etc/nixos/
sudo cp -r modules /etc/nixos/
sudo cp hardware-configuration.nix /etc/nixos/

# Check configuration
sudo nixos-rebuild dry-activate

# Apply configuration
sudo nixos-rebuild switch
```

### 5. Set Up Home Manager (Optional)

```bash
# Add home-manager channel
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update

# Install home-manager
nix-shell '<home-manager>' -A install

# Copy home-manager configuration
mkdir -p ~/.config/nixpkgs
cp -r home/* ~/.config/nixpkgs/

# Apply home-manager configuration
home-manager switch
```

## 🔧 Customization

### Update SSH Keys
Edit `configuration.nix` and replace the placeholder SSH key:
```nix
openssh.authorizedKeys.keys = [
  "ssh-rsa YOUR_ACTUAL_SSH_KEY_HERE"
];
```

### Change Timezone
Edit `configuration.nix`:
```nix
time.timeZone = "Your/Timezone";
```

### Update Hostname
Edit `configuration.nix`:
```nix
networking.hostName = "your-hostname";
```

## 🎯 What You'll Get

After setup, you'll have:
- **KDE Plasma** with beautiful Catppuccin theme
- **Cursor IDE** for development
- **Slack, Discord, Spotify** for communication and media
- **Modern CLI tools** (ripgrep, fd, bat, exa, fzf)
- **Development environment** (Git, Docker, databases)
- **Clean, "riced out"** desktop

## 🐛 Troubleshooting

### Common Issues

1. **Hardware configuration errors**: Make sure to update disk UUIDs in `hardware-configuration.nix`
2. **Network issues**: Check that NetworkManager is enabled
3. **Theme not applying**: Log out and back in, or restart Plasma
4. **Cursor not working**: Ensure it's in the package list

### Useful Commands

```bash
# Check configuration
sudo nixos-rebuild dry-activate

# Update system
sudo nixos-rebuild switch --upgrade

# Rollback if something breaks
sudo nixos-rebuild switch --rollback

# View logs
journalctl -u nixos-rebuild

# Garbage collection
sudo nix-collect-garbage -d
```

## 📝 Notes for CachyOS Users

- This configuration is designed for NixOS, not Arch/CachyOS
- You'll need to install NixOS to use this configuration
- The setup script assumes a NixOS environment
- Consider testing in a VM first

## 🎉 Enjoy!

Once everything is set up, you'll have a beautiful, clean development environment with all the tools you need! 