#!/bin/sh
# Keeps chrome-devtools-axi state out of ~. The tool hard-codes
# ~/.chrome-devtools-axi with no setting to move it, so this rewrites that one
# line in every installed copy to use $XDG_STATE_HOME/chrome-devtools-axi
# (falling back to ~/.local/state). Runs on every apply because an npm update
# of the tool restores the original line; already-patched copies are skipped.

old='const base = join(homedir(), STATE_DIR_NAME);'
new='const base = join(process.env.XDG_STATE_HOME || join(homedir(), ".local", "state"), "chrome-devtools-axi");'

for file in \
    "$HOME"/.local/share/firstmate-tools/pkg/lib/node_modules/chrome-devtools-axi/dist/src/sessions.js \
    "$HOME"/.local/share/firstmate-tools/pkg/node_modules/chrome-devtools-axi/dist/src/sessions.js \
    "$HOME"/.local/share/mise/installs/node/*/lib/node_modules/chrome-devtools-axi/dist/src/sessions.js; do
    [ -f "$file" ] || continue
    if grep -qF "$old" "$file"; then
        OLD="$old" NEW="$new" perl -pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/' "$file"
        echo "chrome-devtools-axi patched for XDG state: $file"
    elif ! grep -qF "$new" "$file"; then
        echo "chrome-devtools-axi: state path line not found, patch needs updating: $file" >&2
    fi
done
