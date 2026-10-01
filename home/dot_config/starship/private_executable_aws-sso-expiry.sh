#!/usr/bin/env bash
# AWS SSO session expiry indicator for Starship prompt.
# Outputs remaining time (e.g. 5h12m, 45m) or 'expired' when active profile SSO session is past expiry.
# Outputs nothing when no profile is active or no valid SSO cache exists.

set -euo pipefail

# 1. Determine active AWS profile (consistent with Starship aws module)
profile="${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-${AWS_VAULT:-${AWS_SSO_PROFILE:-}}}}"
if [ -z "$profile" ]; then
    exit 0
fi

# 2. Locate AWS config file and SSO cache directory
aws_config="${AWS_CONFIG_FILE:-${HOME:-}/.aws/config}"
cache_dir="${HOME:-}/.aws/sso/cache"

if [ ! -d "$cache_dir" ]; then
    exit 0
fi

# 3. Resolve target sso_start_url from active profile in AWS config
target_start_url=""
if [ -f "$aws_config" ]; then
    awk_out=$(awk -v target_prof="$profile" '
    BEGIN { in_profile = 0; sso_url = ""; sso_sess = "" }
    /^\[/ {
        header = $0
        sub(/^\[[ \t]*/, "", header)
        sub(/[ \t]*\].*$/, "", header)
        if (header == "profile " target_prof || header == target_prof || header == "profile \"" target_prof "\"") {
            in_profile = 1
        } else {
            in_profile = 0
        }
    }
    in_profile && /^[ \t]*sso_start_url[ \t]*=/ {
        val = $0
        sub(/^[ \t]*sso_start_url[ \t]*=[ \t]*/, "", val)
        sub(/[ \t\r\n]+$/, "", val)
        gsub(/^["\x27]|["\x27]$/, "", val)
        sso_url = val
    }
    in_profile && /^[ \t]*sso_session[ \t]*=/ {
        val = $0
        sub(/^[ \t]*sso_session[ \t]*=[ \t]*/, "", val)
        sub(/[ \t\r\n]+$/, "", val)
        gsub(/^["\x27]|["\x27]$/, "", val)
        sso_sess = val
    }
    END {
        if (sso_url != "") {
            print "URL:" sso_url
        } else if (sso_sess != "") {
            print "SESSION:" sso_sess
        }
    }
    ' "$aws_config" 2>/dev/null || true)

    case "$awk_out" in
        URL:*)
            target_start_url="${awk_out#URL:}"
            ;;
        SESSION:*)
            sess_name="${awk_out#SESSION:}"
            target_start_url=$(awk -v target_sess="$sess_name" '
            BEGIN { in_session = 0; sso_url = "" }
            /^\[/ {
                header = $0
                sub(/^\[[ \t]*/, "", header)
                sub(/[ \t]*\].*$/, "", header)
                if (header == "sso-session " target_sess || header == target_sess || header == "sso-session \"" target_sess "\"") {
                    in_session = 1
                } else {
                    in_session = 0
                }
            }
            in_session && /^[ \t]*sso_start_url[ \t]*=/ {
                val = $0
                sub(/^[ \t]*sso_start_url[ \t]*=[ \t]*/, "", val)
                sub(/[ \t\r\n]+$/, "", val)
                gsub(/^["\x27]|["\x27]$/, "", val)
                sso_url = val
            }
            END {
                if (sso_url != "") print sso_url
            }
            ' "$aws_config" 2>/dev/null || true)
            ;;
    esac
fi

now="${AWS_SSO_NOW:-$(date +%s)}"

match_result=""
fallback_result=""

shopt -s nullglob
cache_files=("$cache_dir"/*.json)
shopt -u nullglob

if [ ${#cache_files[@]} -eq 0 ]; then
    exit 0
fi

# shellcheck disable=SC2012
while IFS= read -r f; do
    [ -f "$f" ] || continue

    res=$(jq -r --arg target_url "$target_start_url" --argjson now "$now" '
      if (.accessToken? and .expiresAt?) then
        (
          .expiresAt
          | sub("UTC$"; "Z")
          | sub("\\.[0-9]+"; "")
          | sub("\\+00:00$"; "Z")
          | try fromdateiso8601 catch null
        ) as $exp |
        if $exp == null then
          empty
        else
          (if $target_url != "" and .startUrl? == $target_url then "MATCH" else "FALLBACK" end) +
          " " +
          (
            ($exp - $now) as $diff |
            if $diff <= 0 then
              "expired"
            else
              ($diff / 3600 | floor) as $h |
              (($diff % 3600) / 60 | floor) as $m |
              if $h > 0 then
                "\($h)h\($m)m"
              else
                "\($m)m"
              end
            end
          )
        end
      else
        empty
      end
    ' "$f" 2>/dev/null || true)

    case "$res" in
        MATCH\ *)
            match_result="${res#MATCH }"
            break
            ;;
        FALLBACK\ *)
            if [ -z "$fallback_result" ]; then
                fallback_result="${res#FALLBACK }"
            fi
            ;;
    esac
done < <(ls -t "${cache_files[@]}" 2>/dev/null || true)

result="${match_result:-$fallback_result}"
if [ -n "$result" ]; then
    printf '%s\n' "$result"
fi
