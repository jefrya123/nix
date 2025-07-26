# Development Environment Variables

# Editor
export EDITOR="cursor"
export VISUAL="cursor"
export BROWSER="firefox"
export TERMINAL="alacritty"

# Development paths
export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export NODE_PATH="$HOME/.npm-global/lib/node_modules"

# Python
export PYTHONPATH="$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH"
export PIP_USER=yes

# Java
export JAVA_HOME="/usr/lib/jvm/default"
export MAVEN_HOME="/usr/share/maven"

# Database URLs (for development)
export DATABASE_URL="postgresql://dev:dev@localhost:5432/dev"
export REDIS_URL="redis://localhost:6379"

# Development ports
export DEV_PORT="3000"
export API_PORT="8000"

# Git
export GIT_AUTHOR_NAME="Your Name"
export GIT_AUTHOR_EMAIL="your.email@example.com"
export GIT_COMMITTER_NAME="Your Name"
export GIT_COMMITTER_EMAIL="your.email@example.com"

# Security
export GNUPGHOME="$HOME/.gnupg"
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# Development tools
export DOCKER_BUILDKIT=1
export DOCKER_CONTENT_TRUST=1

# Network
export CURL_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
export SSL_CERT_DIR="/etc/ssl/certs"

# Fun
export FORTUNE_PATH="/usr/share/games/fortunes" 