#!/bin/bash

mkdir -p ~/.config/ollauncha

touch ~/.config/ollauncha/remotes

readarray -t REMOTE_HOSTS < ~/.config/ollauncha/remotes || REMOTE_HOSTS=("local|")

while REMOTE_HOSTS=\= read var value; do
    vars+=($var)
    values+=($value)
done < ~/.config/ollauncha/remotes


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
