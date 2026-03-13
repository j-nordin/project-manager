# project-manager

A CLI tool for registering projects and opening them in a predefined i3 workspace layout.

## What it does

Register local project directories, then open them with a single command. The `open` command launches VS Code, Firefox, and Alacritty on a dedicated i3 workspace, arranged automatically:

```
┌────────────────────┬──────────────┐
│                    │   Firefox    │
│                    ├─ stacking ───┤
│     VS Code        │  Alacritty   │
│      (55%)         │    (45%)     │
│                    │              │
└────────────────────┴──────────────┘
```

VS Code takes the left 55%. Firefox and Alacritty share the right side in a stacking layout.

## Dependencies

| Tool | Required for |
|------|-------------|
| **i3** | Window management and layout |
| **jq** | Parsing i3 tree JSON |
| **code** (VS Code) | Editor pane |
| **firefox** | Browser pane |
| **alacritty** | Terminal pane |
| **zsh** + **oh-my-zsh** | Tab completion (optional) |

Core utilities (`grep`, `sed`, `column`, `realpath`) are assumed present.

## Installation

```bash
git clone <repo-url> ~/projects/project-manager
cd ~/projects/project-manager
./install.sh
```

The install script:
- Symlinks the `project` executable to `~/.local/bin/project`
- Symlinks the zsh plugin to `~/.oh-my-zsh/custom/plugins/project`
- Adds `project` to your zsh plugins array in `~/.zshrc`

## Usage

### `project add [path] [--name NAME]`

Register a directory as a project.

```bash
project add                          # register current directory
project add ~/code/my-app            # register a specific path
project add --name web ~/code/app    # register with a custom name
```

Names default to the directory basename, lowercased and sanitized (non-alphanumeric characters become hyphens).

### `project remove <name>`

Unregister a project.

```bash
project remove my-app
```

### `project list [--names-only]`

List all registered projects.

```bash
project list               # formatted table: NAME | PATH
project list --names-only  # just names, one per line
```

### `project open <name> [--workspace N]`

Open a project in a new i3 workspace with the layout shown above.

```bash
project open my-app               # uses first free workspace (1–10)
project open my-app --workspace 3 # open on workspace 3
```

### `project help`

Show usage information.

## Rofi integration

Bind a rofi picker to quickly open projects. Example i3 config:

```
bindsym $mod+p exec --no-startup-id project open "$(project list --names-only | rofi -dmenu -p 'project' | awk '{print $1}')"
```

## Configuration

**Registry location:** `~/.config/project/registry`

Plain text, one project per line:

```
my-app:/home/jonas/code/my-app
website:/home/jonas/projects/website
```

Format is `name:path`. The file is created automatically on first `project add`.
