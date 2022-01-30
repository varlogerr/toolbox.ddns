HELP_DESCRIPTION="
  Update dynamic DNS for ${DDNS_PROVIDER} provider.
  Minimal recommended update interval: ${MIN_UPDATE_INTERVAL} min
"

HELP_USAGE="
  ${THE_SCRIPT} OPTIONS HOSTS...
"

HELP_ENVVARS="
  DDNS_HOSTS - space separated hosts
  DDNS_IP    - ip
  DDNS_PASS  - account password
"

HELP_OPTS="
  --          end of options
  -i, --ip    (optional) specific IP
  -p, --pass  (required) account password
"
