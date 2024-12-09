#!/usr/bin/env bash

set -euo pipefail

NIX_FILE="home.nix"

EXTENSIONS=(
  "tompollak.lazygit-vscode"
  "stateful.runme"
  "IBM.output-colorizer"
  "supermaven.supermaven"
)

get_latest_version() {
  local extension=$1
  local publisher="${extension%%.*}"
  local name="${extension##*.}"
  local response

  response=$(curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery?api-version=3.0-preview.1" \
    -H "Content-Type: application/json" \
    --data-raw '{
      "filters": [
        {
          "criteria": [
            {
              "filterType": 7,
              "value": "'$publisher.$name'"
            }
          ]
        }
      ],
      "assetTypes": [],
      "flags": 103
    }')

  echo "$response" | jq -r '.results[0].extensions[0].versions[0].version'
}

update_nix_file() {
  local name=$1
  local latest_version=$2

  awk -v ext_name="$name" \
      -v new_version="$latest_version" '
    BEGIN { inside_block = 0 }
    {
      if ($0 ~ "name = \"" ext_name "\";") {
        inside_block = 1
      }
      if (inside_block && $0 ~ "version = ") {
        sub(/version = "[^"]+"/, "version = \"" new_version "\"")
      }
      print $0
    }
  ' "$NIX_FILE" > "$NIX_FILE.tmp" && mv "$NIX_FILE.tmp" "$NIX_FILE"
}

for ext in "${EXTENSIONS[@]}"; do
  echo "Processing $ext..."
  NAME="${ext##*.}"

  LATEST_VERSION=$(get_latest_version "$ext")
  if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" ]]; then
    echo "Failed to fetch the latest version for $ext."
    continue
  fi
  echo "Latest version: $LATEST_VERSION"

  update_nix_file "$NAME" "$LATEST_VERSION"
done

echo "Extensions updated in $NIX_FILE."
