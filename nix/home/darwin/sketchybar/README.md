# SketchyBar Configuration

## Concept

**Focus support** - Place current task in the center for easy attention

## Layout

```
[Left: Workspace]          [Center: Focus]          [Right: Status]
 WS  App1 *App2* App3      Task | Timer | Calendar   CPU  Mem  Batt  Time
     ↑ front app highlighted
```

### Sections

| Section | Role | Contents |
|---------|------|----------|
| **Left** | Context | Workspace name + App list (front app highlighted) |
| **Center** | Focus support | Task + Timer + Calendar |
| **Right** | Environment | CPU/Mem/Batt + DateTime |

## Center Section

### Task

Display current task from Obsidian daily note.

**Data Source**: `~/Obsidian/My Vault/Diary/Daily/YYYY-MM-DD.md` under `## Tasks` section

**Task Format**:
- `- [ ]` Uncompleted (displayed)
- `- [x]` Completed
- `- [-]` Cancelled
- `- [>]` Forwarded

**Operations**:
| Action | Behavior |
|--------|----------|
| Left click | Rotate through tasks |
| Shift+click | Clear selection → "No focus" |
| Right click | Show popup menu |

**Popup Menu** (when task selected):
- Complete: Mark as `- [x]` with completion date
- Cancel: Mark as `- [-]`
- Forward: Mark as `- [>]` and add to tomorrow's note
- Open Obsidian: Open daily note

**Popup Menu** (when No focus):
- Open Obsidian only

**Implementation**:
- `task_update.sh`: Extract Tasks section via treemd, filter uncompleted with grep
- `task.sh`: Click handler, popup visibility control
- `task_action.sh`: Complete/Cancel/Forward/Open actions

### Timer

Pomodoro-based timer with preset durations (25/5/1 min) or custom input.

**Display**: `MM:SS` countdown (fixed width, right-aligned)

**Operations**:
| Action | State | Behavior |
|--------|-------|----------|
| Left click | idle | Show popup (25/5/1 min presets) |
| Left click | running | Pause |
| Left click | paused | Resume |
| Left click | break | Skip break |
| Right click | idle | Input custom duration (dialog) |
| Right click | running/paused | Show popup (Pause/Resume/Reset) |
| Shift+click | running/paused | Reset |

**25-minute Pomodoro**: Automatically starts 5-minute break after completion.

**Notification**: Illuminate sound on timer/break completion.

**Implementation**:
- `timer_update.sh`: Display update, break logic, notification
- `timer_click.sh`: Click handler, popup control
- `timer_action.sh`: Start/pause/resume/reset actions

### Calendar

Display next event within 1 hour from Google Calendar.

**Display**: `Title in Xm` (e.g., "Daily meeting in 15m")

**Operations**:
| Action | Behavior |
|--------|----------|
| Left click | Show today's events popup (max 5) |
| Right click | Open Calendar.app |

**Implementation**:
- `calendar_update.sh`: Fetch next event via gcalcli
- `calendar.sh`: Click handler, popup control

## Design

- **Theme**: Dracula
- **Split bar layout**: Transparent bar with independent section brackets
- **Rounded corner overlap**: Workspace and clock have colored backgrounds that overlap with adjacent items
- **No transparency**: Solid colors to avoid blending issues at overlaps
- **Colors**: Use existing palette in `plugins/colors.sh`, do not add new colors

## Dependencies

- **Aerospace**: Workspace management
- **SF Pro**: System font for icons and labels
- **treemd**: Markdown section extraction
- **gcalcli**: Google Calendar CLI

## Operations

Managed by Nix, launched via launchd (not Homebrew services).

```bash
# Reload config (use this, not pkill)
sketchybar --reload

# Restart media stream service
launchctl stop com.sketchybar.media-stream && launchctl start com.sketchybar.media-stream
```
