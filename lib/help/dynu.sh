HELP_DESCRIPTION="$(while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<<  "
    Update dynamic DNS for ${DDNS_PROVIDER} provider.
    Minimal recommended update interval: ${MIN_UPDATE_INTERVAL} min
  ")"

HELP_USAGE="$(while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    ${THE_SCRIPT} OPTIONS [HOSTS...]
  ")"

HELP_OPTS+="
  -u, --user  (required) account username
"

HELP_ENVVARS+="
  DDNS_USER  - account username
"

HELP_DEMO="
  # all dns records will be updated
  # if no hosts provided
  ${THE_SCRIPT} -p foo -u bar
  # update specific domains to
  # specific ip
  ${THE_SCRIPT} -p foo -u bar -i 8.8.8.8 \\
  x.giize.com y.giize.com
"
