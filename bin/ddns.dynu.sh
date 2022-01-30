#!/usr/bin/env bash

# https://www.dynu.com/DynamicDNS/IP-Update-Protocol

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://api.dynu.com/nic/update?"
DDNS_PROVIDER="dynu"
MIN_UPDATE_INTERVAL=5
IP_PROVIDER=""

. "${TOOL_DIR}/lib/bootstrap.sh"

[[ -n "${OPTS[ip]}" ]] && {
  API_URL+="&myip=${OPTS[ip]}"
} || {
  OPTS[ip]="$(get_current_ip)"
}
[[ -z "${OPTS[ip]}" ]] && OPTS[ip]="NOT_DETECTED"

print_log "IP: ${OPTS[ip]}"

[[ -z "${OPTS[hosts]}" ]] && {
  result="$(
    curl -ks --basic -u "${OPTS[user]}:${OPTS[pass]}" \
      -K - <<< "url=${API_URL}"
  )"
  print_log "(all) ${result}"
  exit
}

# convert from newline and comma separated
# to space separated
csv_hosts="$(
  tr ',' '\n' <<< "${OPTS[hosts]}" | grep -vFx '' \
  | tr '\n' ' '
)"

for h in ${csv_hosts}; do
  result="$(
    curl -ks --basic -u "${OPTS[user]}:${OPTS[pass]}" \
      -K - <<< "url=${API_URL}&hostname=${h}"
  )"
  print_log "(${h}) ${result}"
done
