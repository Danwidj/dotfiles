# Status Line Configuration (`dot_config/statusline/`)

Houses tool-neutral status line scripts following XDG conventions.

### Files

- **`private_executable_statusline.sh`**: Maps to `~/.config/statusline/statusline.sh` (executable). Reads status line JSON on stdin via a single, fast `jq` invocation and prints a single line:
  `<model.display_name> | ctx <tokens> | 5h <five_hour %> resets <HH:MM> | week <seven_day %> resets <Ddd HH:MM>`
  No ANSI colors, symbols, progress bars, or folder/git details. Each segment appears only when present.
