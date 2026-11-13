# Loop Configuration (`dot_config/loop/`)

Houses the keybindings for [Loop](https://github.com/MrKai77/Loop), the macOS window manager.

### Files

- **`loop-keybinds.json`**: Loop keybinds in its JSON import/export format. Ported from the old Rectangle shortcuts (Ctrl+Opt+key, Loop trigger key is Ctrl+Opt) plus the kept Loop defaults.

> **Import Note**: Loop keybinds cannot be applied from the shell. After bootstrapping, open **Loop → Settings → Keybinds → Import** and select `~/.config/loop/loop-keybinds.json`, then choose **Erase** to replace existing keybinds. To track later changes, use **Export** and overwrite the file in the chezmoi source.
>
> Rectangle shortcuts with no Loop action: Center Two Thirds (Ctrl+Opt+R), Toggle Todo, Reflow Todo.
