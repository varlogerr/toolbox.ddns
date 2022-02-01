#!/usr/bin/env bash

# https://www.duckdns.org/spec.jsp
# https://www.duckdns.org/install.jsp

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://www.duckdns.org/update?"
DDNS_PROVIDER="duckdns"
MIN_UPDATE_INTERVAL=5
IP_PROVIDER=""

. "${TOOL_DIR}/lib/bootstrap.sh"

[[ -n "${OPTS[ip]}" ]] && {
  API_URL+="&ip=${OPTS[ip]}"
} || {
  OPTS[ip]="$(get_current_ip)"
}
[[ -z "${OPTS[ip]}" ]] && OPTS[ip]="NOT_DETECTED"

print_log "IP: ${OPTS[ip]}"

# convert from newline and space separated
# to comma separated
csv_hosts="$(
  tr ' ' '\n' <<< "${OPTS[hosts]}" | grep -vFx '' \
  | tr '\n' ',' | sed 's/,$//g'
)"

API_URL+="&domains=${csv_hosts}&token=${OPTS[pass]}"

result="$(curl -ks -K - <<< "url=${API_URL}")"
for d in $(tr ',' ' ' <<< "${csv_hosts}"); do
  print_log "(${d}) ${result}"
done
