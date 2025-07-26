#!/bin/bash

# NixOS Developer Workstation Setup Script
# This script helps you set up the NixOS configuration

set -e

echo "🚀 Setting up NixOS Developer Workstation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check if we're on NixOS
if [[ ! -f /etc/nixos/configuration.nix ]]; then
    print_warning "This doesn't appear to be a NixOS system"
    print_status "Make sure you're running this on NixOS"
fi

# Generate hardware configuration if it doesn't exist
if [[ ! -f hardware-configuration.nix ]]; then
    print_status "Generating hardware configuration..."
    sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
    print_success "Hardware configuration generated"
    print_warning "Please review and edit hardware-configuration.nix before proceeding"
else
    print_status "Hardware configuration already exists"
fi

# Check if configuration files exist
if [[ ! -f configuration.nix ]]; then
    print_error "configuration.nix not found!"
    print_status "Make sure you're in the correct directory"
    exit 1
fi

# Backup existing configuration
if [[ -f /etc/nixos/configuration.nix ]]; then
    print_status "Backing up existing configuration..."
    sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup.$(date +%Y%m%d_%H%M%S)
    print_success "Backup created"
fi

# Copy configuration files
print_status "Copying configuration files..."
sudo cp configuration.nix /etc/nixos/
sudo cp -r modules /etc/nixos/
sudo cp hardware-configuration.nix /etc/nixos/

print_success "Configuration files copied"

# Check configuration
print_status "Checking configuration..."
if sudo nixos-rebuild dry-activate; then
    print_success "Configuration check passed"
else
    print_error "Configuration check failed"
    print_status "Please fix the errors and try again"
    exit 1
fi

# Ask user if they want to apply the configuration
echo
print_status "Configuration is ready to apply"
read -p "Do you want to apply the configuration now? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Applying configuration..."
    sudo nixos-rebuild switch
    print_success "Configuration applied successfully!"
    print_status "You may need to log out and back in for all changes to take effect"
else
    print_status "Configuration ready. Run 'sudo nixos-rebuild switch' when ready"
fi

# Setup home-manager (optional)
echo
print_status "Setting up home-manager..."
read -p "Do you want to set up home-manager? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Installing home-manager..."
    
    # Add home-manager channel
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
    nix-channel --update
    
    # Install home-manager
    nix-shell '<home-manager>' -A install
    
    # Copy home-manager configuration
    if [[ -d home ]]; then
        mkdir -p ~/.config/nixpkgs
        cp -r home/* ~/.config/nixpkgs/
        print_success "Home-manager configuration copied"
        
        # Apply home-manager configuration
        print_status "Applying home-manager configuration..."
        home-manager switch
        print_success "Home-manager configuration applied"
    else
        print_warning "Home-manager configuration directory not found"
    fi
else
    print_status "Skipping home-manager setup"
fi

echo
print_success "Setup complete! 🎉"
print_status "Your NixOS developer workstation is ready"
print_status "Don't forget to:"
print_status "  - Update your SSH keys in configuration.nix"
print_status "  - Customize the timezone and hostname"
print_status "  - Review the hardware configuration" 