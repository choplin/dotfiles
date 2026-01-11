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

## Dependencies

- **Aerospace**: Workspace management
- **SF Pro**: System font for icons and labels
