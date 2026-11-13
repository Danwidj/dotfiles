# Loop Configuration (`dot_config/loop/`)

Houses the keybindings for [Loop](https://github.com/MrKai77/Loop), the macOS window manager.

### Files

- **`loop-keybinds.json`**: Loop keybinds in its JSON import/export format. The Loop trigger key is Fn. Fn+arrows snap and cycle sizes, Fn+H/J/K/L move focus between windows, Fn+; cycles stacked windows, Fn+O fills the available space, and Fn+Cmd+U/I/J/K stash to a corner.

> **Apply Note**: `chezmoi apply` writes this file into Loop's preferences through `.chezmoiscripts/run_onchange_after_apply-loop-keybinds.sh.tmpl` whenever the file changes (it quits and reopens Loop), so no manual import is needed. Edit the JSON, then run `chezmoi apply`. The script writes Loop's own preference keys (`keybinds`, `trigger`); if a Loop update changes that format, fall back to **Loop → Settings → Keybinds → Import** with **Erase**.
>
> Keybinds changed inside Loop's settings are overwritten on the next apply; use **Export** and overwrite the file in the chezmoi source to keep them.
>
> Rectangle shortcuts with no Loop action: Center Two Thirds (Ctrl+Opt+R), Toggle Todo, Reflow Todo.
