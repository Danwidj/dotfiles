#!/usr/bin/env bash
# Plain, tool-neutral status line reading JSON session data from stdin.

exec jq -R -r -s '
def fmt_tokens:
  if . >= 1000000 then
    ((. / 1000000) * 10 | round) as $r |
    "\($r / 10 | floor).\($r % 10)M"
  else
    "\((. / 1000) | round)k"
  end;

def fmt_5h_resets:
  ((try (select(type == "number" and . > 0) | strflocaltime("%H:%M")) catch null) // null);

def fmt_week_resets:
  ((try (select(type == "number" and . > 0) | strflocaltime("%a %H:%M")) catch null) // null);

(try fromjson catch {}) as $in |
[
  ($in.model? | if type == "object" then (.display_name // .id // empty) elif type == "string" and . != "" then . else empty end),
  (if ($in.context_window?.total_input_tokens? != null and ($in.context_window.total_input_tokens | type == "number" and . >= 0)) then
    "ctx \($in.context_window.total_input_tokens | fmt_tokens)"
   else empty end),
  (if ($in.rate_limits?.five_hour?.used_percentage? != null and ($in.rate_limits.five_hour.used_percentage | type == "number")) then
    ($in.rate_limits.five_hour.resets_at? | fmt_5h_resets) as $r |
    "5h \($in.rate_limits.five_hour.used_percentage | round)%" + (if $r != null then " resets \($r)" else "" end)
   else empty end),
  (if ($in.rate_limits?.seven_day?.used_percentage? != null and ($in.rate_limits.seven_day.used_percentage | type == "number")) then
    ($in.rate_limits.seven_day.resets_at? | fmt_week_resets) as $r |
    "week \($in.rate_limits.seven_day.used_percentage | round)%" + (if $r != null then " resets \($r)" else "" end)
   else empty end)
] | join(" | ")
'
