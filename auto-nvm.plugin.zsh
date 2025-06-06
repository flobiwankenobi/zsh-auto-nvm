#!/usr/bin/env zsh

command -v nvm &>/dev/null || {
  echo "⚠️ auto-nvm: nvm is not installed"
  return 1
}

NVMRC_FILE=".nvmrc"
PACKAGE_FILE="package.json"

_get_current_node_major() {
  node -v 2>/dev/null | cut -d. -f1 | tr -d 'v'
}

_get_node_version_from_package() {
  node -e '
    try {
      const { engines } = require("./package.json");
      if (!engines?.node) process.exit(0);
      const versions = engines.node
        .split("||")
        .map(v => parseInt(v.match(/\d+/)?.[0]))
        .filter(Boolean);
      if (versions.length) console.log(Math.max(...versions));
    } catch {}
  ' 2>/dev/null
}

_switch_node_version() {
  local target_version=$1
  local current_major=$(_get_current_node_major)

  if [[ "$current_major" != "$target_version" ]]; then
    nvm use "$target_version" --silent || nvm install "$target_version" --silent
  fi
}

_handle_package_json_version() {
  local target_version=$(_get_node_version_from_package)

  if [[ -n "$target_version" ]]; then
    _switch_node_version "$target_version"
    return 0
  fi
  return 1
}

auto_nvm() {
  if [[ " ${plugins[*]} " == *" nvm "* ]] && [[ -f "$NVMRC_FILE" ]]; then
    return 0
  fi

  if [[ -f "$NVMRC_FILE" ]]; then
    nvm use --silent || nvm install --silent
    return
  fi

  if [[ -f "$PACKAGE_FILE" ]]; then
    _handle_package_json_version && return
  fi

  [[ "$(node -v 2>/dev/null)" == "$(nvm version default 2>/dev/null)" ]] || nvm use default --silent
}

autoload -U add-zsh-hook
add-zsh-hook chpwd auto_nvm
auto_nvm
