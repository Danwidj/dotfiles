# Loop Configuration (`dot_config/loop/`)

Houses the keybindings for [Loop](https://github.com/MrKai77/Loop), the macOS window manager.

### Files

- **`loop-keybinds.json`**: Loop keybinds in its JSON import/export format. The Loop trigger key is Fn. Fn+arrows snap and cycle sizes, Fn+H/J/K/L move focus between windows, Fn+; cycles stacked windows, Fn+O fills the available space, and Fn+Cmd+U/I/J/K stash to a corner.

> **Import Note**: Loop keybinds cannot be applied from the shell. After bootstrapping, open **Loop → Settings → Keybinds → Import** and select `~/.config/loop/loop-keybinds.json`, then choose **Erase** to replace existing keybinds. To track later changes, use **Export** and overwrite the file in the chezmoi source.
>
> Rectangle shortcuts with no Loop action: Center Two Thirds (Ctrl+Opt+R), Toggle Todo, Reflow Todo.
