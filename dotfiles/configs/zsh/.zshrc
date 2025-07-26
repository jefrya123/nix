# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="agnoster"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    npm
    python
    vscode
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load aliases
if [[ -f ~/.zsh_aliases ]]; then
    source ~/.zsh_aliases
fi

# Load environment variables
if [[ -f ~/.env ]]; then
    source ~/.env
fi

# Starship prompt (if installed)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# History configuration
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=10000

# Better completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Development environment setup
if command -v nvm &> /dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Rust
if [[ -f ~/.cargo/env ]]; then
    source ~/.cargo/env
fi

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Python
export PATH="$PATH:$HOME/.local/bin"

# Welcome message
echo "🚀 Welcome to your development environment!"
echo "Type 'help' for available commands" 