# Starship Configuration (`dot_config/starship/`)

Houses helper scripts and configurations for custom Starship prompt modules.

### Files

- **`private_executable_aws-sso-expiry.sh`**: Maps to `~/.config/starship/aws-sso-expiry.sh` (executable). Fast helper script reading AWS SSO cache data in `~/.aws/sso/cache/*.json` using `jq` and `date`. Resolves the active profile's `sso_start_url` or `sso_session` from `$AWS_CONFIG_FILE` / `~/.aws/config`, selects the matching cache entry or falls back to the newest valid cache file, and outputs the remaining time (`XhYm` or `Ym`) or `expired`. Outputs nothing when no SSO cache exists or no AWS profile is active. Never prints or logs the access token.
