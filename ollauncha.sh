#!/bin/bash

mkdir -p ~/.config/ollauncha

touch ~/.config/ollauncha/remotes


# Initialize the variable/list
REMOTE_HOSTS=""

# Check if the file exists and is readable
if [ -r "$HOME/.config/ollauncha/remotes" ]; then
    # Read file line by line into a space-separated string or positional parameters
    while IFS= read -r line || [ -n "$line" ]; do
        REMOTE_HOSTS="${REMOTE_HOSTS}${line} "
    done < "$HOME/.config/ollauncha/remotes"
fi

# If REMOTE_HOSTS is still empty, apply the fallback
if [ -z "$REMOTE_HOSTS" ]; then
    REMOTE_HOSTS="local|"
fi


choice=$(printf "%s\n" "${REMOTE_HOSTS[@]}" | fzf --prompt="Select Ollama host: ")

[[ -z "$choice" ]] && exit 1

name="${choice%%|*}"
host="${choice##*|}"

if [[ -z "$host" ]]; then
  echo "Using local Ollama"
  exec ollama $@
else
  echo "Using $name ($host)"
  OLLAMA_HOST="$host" exec ollama $@
fi
