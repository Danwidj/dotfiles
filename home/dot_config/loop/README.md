# Loop Configuration (`dot_config/loop/`)

Houses the keybindings and settings for [Loop](https://github.com/MrKai77/Loop), the macOS window manager.

### Files

- **`loop-keybinds.json`**: Loop keybinds in its JSON import/export format. The Loop trigger key is Fn. Fn+arrows snap and cycle sizes, Fn+H/J/K/L move focus between windows, Fn+; cycles stacked windows, Fn+O fills the available space, Fn+Cmd+U/I/J/K stash to a corner (unstashed size 50% wide, 40% tall), and Fn+Cmd+N/M stash to the left and right edges (80% by 80%).
- **`loop-settings.json`**: Every other Loop setting (padding, preview, radial menu, stash, trigger and menu bar options), as plain JSON keyed by Loop's own preference names. Runtime state (stashed windows, the usage counter, sync timestamps, macOS window positions) is left out.

> **Apply Note**: `chezmoi apply` writes both files into Loop's preferences through `.chezmoiscripts/run_onchange_after_apply-loop-keybinds.sh.tmpl` whenever either file changes (it quits and reopens Loop), so no manual import is needed. Edit the JSON, then run `chezmoi apply`. The script writes Loop's own preference keys (`keybinds`, `trigger`, and each key in `loop-settings.json`) and turns off `useSystemWindowManagerWhenAvailable`, so Loop sizes windows itself and macOS tiling cannot snap them back to full size; if a Loop update changes that format, fall back to **Loop → Settings → Keybinds → Import** with **Erase**.
>
> Keybinds and settings changed inside Loop's settings window are overwritten on the next apply. To keep them, run `mise run loop-save` from the chezmoi source: it reads Loop's live preferences and rewrites both files. Review with `git diff`, then commit.
>
> Rectangle shortcuts with no Loop action: Center Two Thirds (Ctrl+Opt+R), Toggle Todo, Reflow Todo.
