# Auto NVM Plugin

Automatically switches to the correct Node.js LTS version based on the `engines.node` configuration in `package.json`.

## Features

- Auto-switches when entering a directory
- Supports version ranges (uses highest allowed LTS version)
- LTS versions only (even numbers)
- Auto-installs missing versions
- Dependency checking (nvm)

## Installation

1. Clone the repository into your Oh My Zsh custom plugins directory:
```bash
git clone https://github.com/flobiwankenobi/zsh-auto-nvm ~/.oh-my-zsh/custom/plugins/auto-nvm
```

2. Enable the plugin in your `.zshrc`:
``` bash
plugins=(... auto-nvm)
```

## Usage
Simply cd into a directory containing a : `package.json`
``` json
{
  "engines": {
    "node": ">=18 <22"  // Will use Node.js 20 LTS
  }
}
```

Activate the plugin by adding it to your plugins list in `.zshrc`:

```bash
plugins=(... auto-nvm)
```

The plugin:
- Checks for nvm availability
- Loads default Node version if none is active
- Only switches versions when necessary (performance)
- Suppresses unnecessary output
- Error-tolerant implementation
- Well documented for other users

After installation:
1. Run `source ~/.zshrc`
2. The plugin will automatically activate and check on every directory change
