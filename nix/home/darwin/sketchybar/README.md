# SketchyBar Configuration

## Concept

**Focus support** - Place current task in the center for easy attention

## Layout

```
[Left: Workspace]          [Center: Focus]          [Right: Status]
 WS  App1 *App2* App3      Task | Pomodoro          CPU  Mem  Batt  Time
     ↑ front app highlighted
```

### Sections

| Section | Role | Contents |
|---------|------|----------|
| **Left** | Context | Workspace name + App list (front app highlighted) |
| **Center** | Focus support | Task + Pomodoro |
| **Right** | Environment | CPU/Mem/Batt + DateTime |

## Design

- **Theme**: Dracula
- **Split bar layout**: Transparent bar with independent section brackets
- **Rounded corner overlap**: Workspace and clock have colored backgrounds that overlap with adjacent items
- **No transparency**: Solid colors to avoid blending issues at overlaps
- **Colors**: Use existing palette in `plugins/colors.sh`, do not add new colors

## Dependencies

- **Aerospace**: Workspace management
- **SF Pro**: System font for icons and labels

## Operations

Managed by Nix, launched via launchd (not Homebrew services).

```bash
# Reload config (use this, not pkill)
sketchybar --reload

# Restart media stream service
launchctl stop com.sketchybar.media-stream && launchctl start com.sketchybar.media-stream
```
