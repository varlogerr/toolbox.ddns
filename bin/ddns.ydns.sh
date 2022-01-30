#!/usr/bin/env bash

# https://github.com/ydns/bash-updater

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://ydns.io/api/v1/update/?"
DDNS_PROVIDER="ydns"
MIN_UPDATE_INTERVAL=15
IP_PROVIDER="https://ydns.io/api/v1/ip"

. "${TOOL_DIR}/lib/bootstrap.sh"

[[ -z "${OPTS[ip]}" ]] && {
  OPTS[ip]="$(get_current_ip)"
}
[[ -z "${OPTS[ip]}" ]] && {
  echo "Can't detect current IP!" >&2
  exit 1
}

API_URL+="&ip=${OPTS[ip]}"

print_log "IP: ${OPTS[ip]}"

# convert from newline and comma separated
# to space separated
csv_hosts="$(
  tr ',' '\n' <<< "${OPTS[hosts]}" | grep -vFx '' \
  | tr '\n' ' '
)"

for h in ${csv_hosts}; do
  result="$(
    curl -ks --basic -u "${OPTS[user]}:${OPTS[pass]}" \
      -K - <<< "url=${API_URL}&host=${h}"
  )"
  print_log "(${h}) ${result}"
done
