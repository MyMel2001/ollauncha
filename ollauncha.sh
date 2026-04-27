#!/bin/bash

# Ensure config directory and file exist
mkdir -p "$HOME/.config/ollauncha"
touch "$HOME/.config/ollauncha/remotes"

# 1. Read the file into a temporary variable
# We use a newline character as a separator for fzf
if [ -s "$HOME/.config/ollauncha/remotes" ]; then
    # Filter out empty lines and read the file
    REMOTE_HOSTS=$(grep '[^[:space:]]' "$HOME/.config/ollauncha/remotes")
else
    REMOTE_HOSTS="local|"
fi

# 2. Pass to fzf
# We use echo "$REMOTE_HOSTS" to ensure newlines are preserved for fzf
choice=$(echo "$REMOTE_HOSTS" | fzf --prompt="Select Ollama host: ")

# Exit if no choice made (ESC or Ctrl-C)
[ -z "$choice" ] && exit 1

# 3. Parse the name and host
name="${choice%%|*}"
host="${choice##*|}"

if [ -z "$host" ]; then
    echo "Using local Ollama"
    exec ollama "$@"
else
    echo "Using $name ($host)"
    OLLAMA_HOST="$host" OLLAMA_CONTEXT_LENGTH=42000 exec ollama "$@"
fi
