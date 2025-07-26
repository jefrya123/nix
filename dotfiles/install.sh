#!/bin/bash

# Developer Dotfiles Installer
# Cross-platform dotfiles setup for Linux, macOS, and Windows

set -e

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

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="linux";;
        Darwin*)    OS="macos";;
        CYGWIN*)    OS="windows";;
        MINGW*)     OS="windows";;
        MSYS*)      OS="windows";;
        *)          OS="unknown";;
    esac
    print_status "Detected OS: $OS"
}

# Create backup directory
create_backup() {
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    echo "$backup_dir"
}

# Backup existing file
backup_file() {
    local file="$1"
    local backup_dir="$2"
    
    if [[ -f "$file" ]]; then
        print_status "Backing up $file"
        cp "$file" "$backup_dir/"
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local backup_dir="$3"
    
    # Backup existing file
    backup_file "$target" "$backup_dir"
    
    # Remove existing file/symlink
    if [[ -L "$target" ]] || [[ -f "$target" ]]; then
        rm "$target"
    fi
    
    # Create symlink
    ln -sf "$source" "$target"
    print_success "Linked $source -> $target"
}

# Install Zsh
install_zsh() {
    print_status "Setting up Zsh..."
    
    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Install Zsh plugins
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    fi
    
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    fi
    
    print_success "Zsh setup complete"
}

# Install Starship prompt
install_starship() {
    print_status "Installing Starship prompt..."
    
    if ! command -v starship &> /dev/null; then
        if [[ "$OS" == "macos" ]]; then
            brew install starship
        elif [[ "$OS" == "linux" ]]; then
            curl -sS https://starship.rs/install.sh | sh
        else
            print_warning "Please install Starship manually for Windows"
        fi
    fi
    
    print_success "Starship installed"
}

# Install modern CLI tools
install_cli_tools() {
    print_status "Installing modern CLI tools..."
    
    if [[ "$OS" == "macos" ]]; then
        # Install via Homebrew
        brew install exa bat ripgrep fd fzf jq tmux
    elif [[ "$OS" == "linux" ]]; then
        # Try to install via package manager
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y exa bat ripgrep fd-find fzf jq tmux
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm exa bat ripgrep fd fzf jq tmux
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y exa bat ripgrep fd-find fzf jq tmux
        else
            print_warning "Please install CLI tools manually for your distribution"
        fi
    else
        print_warning "Please install CLI tools manually for Windows"
    fi
    
    print_success "CLI tools installed"
}

# Main installation function
main() {
    print_status "🚀 Starting dotfiles installation..."
    
    # Detect OS
    detect_os
    
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Create backup directory
    BACKUP_DIR=$(create_backup)
    print_status "Backup directory: $BACKUP_DIR"
    
    # Install dependencies
    install_zsh
    install_starship
    install_cli_tools
    
    # Create symlinks
    print_status "Creating symlinks..."
    
    # Zsh
    create_symlink "$SCRIPT_DIR/configs/zsh/.zshrc" "$HOME/.zshrc" "$BACKUP_DIR"
    create_symlink "$SCRIPT_DIR/configs/zsh/.zsh_aliases" "$HOME/.zsh_aliases" "$BACKUP_DIR"
    
    # Git
    create_symlink "$SCRIPT_DIR/configs/git/.gitconfig" "$HOME/.gitconfig" "$BACKUP_DIR"
    create_symlink "$SCRIPT_DIR/configs/git/.gitignore_global" "$HOME/.gitignore_global" "$BACKUP_DIR"
    
    # SSH
    if [[ -d "$SCRIPT_DIR/configs/ssh" ]]; then
        mkdir -p "$HOME/.ssh"
        create_symlink "$SCRIPT_DIR/configs/ssh/config" "$HOME/.ssh/config" "$BACKUP_DIR"
    fi
    
    # Alacritty
    if [[ "$OS" != "windows" ]]; then
        mkdir -p "$HOME/.config/alacritty"
        create_symlink "$SCRIPT_DIR/configs/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml" "$BACKUP_DIR"
    fi
    
    # Cursor IDE
    if [[ "$OS" == "macos" ]]; then
        mkdir -p "$HOME/Library/Application Support/Cursor/User"
        create_symlink "$SCRIPT_DIR/configs/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json" "$BACKUP_DIR"
    elif [[ "$OS" == "linux" ]]; then
        mkdir -p "$HOME/.config/Cursor/User"
        create_symlink "$SCRIPT_DIR/configs/cursor/settings.json" "$HOME/.config/Cursor/User/settings.json" "$BACKUP_DIR"
    fi
    
    # VS Code
    if [[ "$OS" == "macos" ]]; then
        mkdir -p "$HOME/Library/Application Support/Code/User"
        create_symlink "$SCRIPT_DIR/configs/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" "$BACKUP_DIR"
    elif [[ "$OS" == "linux" ]]; then
        mkdir -p "$HOME/.config/Code/User"
        create_symlink "$SCRIPT_DIR/configs/vscode/settings.json" "$HOME/.config/Code/User/settings.json" "$BACKUP_DIR"
    fi
    
    # Environment variables
    create_symlink "$SCRIPT_DIR/configs/env.sh" "$HOME/.env" "$BACKUP_DIR"
    
    print_success "🎉 Installation complete!"
    print_status "Please restart your terminal or run: source ~/.zshrc"
    print_status "Backup of old configs saved to: $BACKUP_DIR"
}

# Run main function
main "$@" 