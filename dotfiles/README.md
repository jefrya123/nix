# Developer Dotfiles

Cross-platform dotfiles for a clean, productive development environment. Works on Linux, macOS, and Windows.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Run the setup script
./install.sh
```

## ✨ What's Included

### Terminal & Shell
- **Zsh** with Oh My Zsh
- **Alacritty** terminal with Catppuccin theme
- **Starship** prompt
- **FZF** fuzzy finder
- **Exa** modern ls replacement
- **Bat** better cat
- **Ripgrep** fast grep

### Development Tools
- **Git** with nice aliases and config
- **SSH** configuration
- **GPG** setup
- **Docker** aliases
- **Node.js** and **Python** helpers

### Applications
- **Cursor IDE** configuration
- **VS Code** settings
- **Firefox** user preferences
- **Spotify** (if available)

### System
- **Environment variables**
- **Path configurations**
- **Aliases** for common tasks

## 📁 Structure

```
dotfiles/
├── install.sh              # Main installation script
├── configs/                # Configuration files
│   ├── zsh/               # Zsh configuration
│   ├── git/               # Git configuration
│   ├── alacritty/         # Terminal configuration
│   ├── cursor/            # Cursor IDE settings
│   └── firefox/           # Firefox preferences
├── scripts/               # Utility scripts
└── README.md             # This file
```

## 🔧 Customization

### Adding New Configs
1. Add your config file to `configs/`
2. Update `install.sh` to symlink it
3. Commit and push

### Platform-Specific
The install script detects your OS and applies appropriate configurations.

## 🎨 Themes

- **Catppuccin Mocha** dark theme
- **JetBrains Mono** font
- **Clean, minimal** design

## 🚀 Usage

After installation:
- Open a new terminal to see the new shell
- Use `z` for quick directory jumping
- Use `fzf` for fuzzy finding
- Use `exa` instead of `ls`
- Use `bat` instead of `cat`

## 📝 Notes

- Works on Linux, macOS, and Windows (WSL)
- Backs up existing configs before overwriting
- Non-destructive installation
- Easy to customize and extend 