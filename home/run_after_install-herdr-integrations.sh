#!/bin/sh
# Ensures the herdr agent integration for claude is installed, so
# native agent session restore works (`[session] resume_agents_on_restore`
# in .config/herdr). Pi was dropped on purpose; re-add to the loop if needed.
# Only claude is integrated; the rest stay untouched (see `herdr integration status`).
#
# Runs on every apply and no-ops quietly when already current, so a
# fresh machine converges as soon as the agent config dirs exist (Claude
# creates ~/.claude on first run; `herdr integration install` requires them).
# Installed files are herdr-managed and version-stamped, so they are deliberately
# NOT vendored into chezmoi — reinstalling via the CLI always yields the
# current bundled version instead of a stale copy.

if ! command -v herdr >/dev/null 2>&1; then
    # herdr not on PATH on this machine (e.g. Linux CI smoke test) — nothing to do.
    exit 0
fi

status="$(herdr integration status 2>/dev/null || true)"
for agent in claude; do
    if printf '%s\n' "$status" | grep -q "^$agent: current"; then
        continue
    fi
    if herdr integration install "$agent"; then
        echo "herdr integration installed: $agent"
    else
        # Non-fatal: the agent config dir may not exist yet (e.g. Claude never
        # launched on a fresh machine). Next apply retries.
        echo "warning: herdr integration install $agent failed; will retry on next apply" >&2
    fi
done
