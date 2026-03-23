# oc — OpenCode Config CLI

[中文文档](README.md)

A CLI tool for quickly toggling OpenCode configuration options. Directly edits JSONC config files while fully preserving comments, indentation, and trailing commas.

## Why `omo`?

The [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) (omo) plugin supercharges OpenCode with powerful enhancements, but it significantly increases the system prompt size. In lightweight modes like `build` and `plan`, this overhead slows down responses and wastes tokens.

`omo` lets you toggle the plugin from your terminal in one keystroke — `omo off` before switching to a lightweight mode, `omo on` when you need full power — no manual config editing required.

```bash
omo off                         # Disable omo → lightweight mode for build/plan
omo on                          # Enable omo → full enhanced mode
omo                             # Check current plugin status
```

## Installation

One-click install (clone and run locally):

```bash
git clone https://github.com/nickrunning/opencode-tool.git
cd opencode-tool
bash install.sh
```

Or install remotely:

```bash
curl -fsSL https://raw.githubusercontent.com/nickrunning/opencode-tool/master/install.sh | bash
```

The install script will automatically:
- Create `~/.local/bin/oc` (symlink locally, download remotely)
- Add the `omo` shortcut function to `~/.bashrc` and `~/.zshrc`

## Usage

### Plugin Management

```bash
oc plugin list                  # List all plugins with status
oc plugin toggle <name>         # Toggle plugin (comment ↔ uncomment)
oc plugin enable <name>         # Enable a plugin
oc plugin disable <name>        # Disable a plugin
```

### Provider Management

```bash
oc provider list                # List all providers with status
oc provider toggle <name>       # Add/remove from disabled_providers
oc provider enable <name>       # Remove from disabled_providers
oc provider disable <name>      # Add to disabled_providers
```

### Model Switching

```bash
oc model                        # Show current model
oc model list                   # List all available models
oc model set <model_id>         # Switch primary model
oc model set-small <model_id>   # Switch small model
oc model <model_id>             # Quick switch primary model
```

## Design

- **Line-level editing**: All writes edit text lines directly — no parse → dump — so comments, blank lines, and indentation are preserved as-is
- **JSONC-aware parsing**: Read-only operations use a state-machine stripper (correctly skips `//` inside strings like URLs) before `json.loads`
- **Plugin toggle**: Comments/uncomments the corresponding line in the `"plugin"` array
- **Provider toggle**: Adds/removes entries in the `"disabled_providers"` array
- **Zero dependencies**: Pure Python 3 stdlib, no pip install needed
