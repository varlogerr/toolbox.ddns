HELP_OPTS+="
  -u, --user  (required) account username
"

HELP_ENVVARS+="
  DDNS_USER  - account username
"

HELP_DEMO="
  # update multiple dns records
  ${THE_SCRIPT} -p foo -u bar x.ydns.eu y.ydns.eu
  # update multiple dns records
  # specific ip
  ${THE_SCRIPT} -p foo -u bar -i 8.8.8.8 \\
  x.ydns.eu y.ydns.eu
"
