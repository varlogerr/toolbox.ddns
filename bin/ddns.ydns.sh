#!/usr/bin/env bash

# https://github.com/ydns/bash-updater

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://ydns.io/api/v1/update/?"
DDNS_PROVIDER="ydns"
MIN_UPDATE_INTERVAL=15
IP_PROVIDER="https://ydns.io/api/v1/ip"

. "${TOOL_DIR}/lib/bootstrap.sh"

LOG_TOOLNAME=ydns

[[ -z "${OPTS[ip]}" ]] && {
  OPTS[ip]="$(get_current_ip)"
}
[[ -z "${OPTS[ip]}" ]] && {
  echo "Can't detect current IP!" >&2
  exit 1
}

API_URL+="&ip=${OPTS[ip]}"

log_info "IP: ${OPTS[ip]}"

# convert from newline and comma separated
# to space separated
csv_hosts="$(
  tr ',' '\n' <<< "${OPTS[hosts]}" | grep -vFx '' \
  | tr '\n' ' '
)"

declare -a req_cmd=(curl -ks --basic -u "${OPTS[user]}:${OPTS[pass]}")
"${req_cmd[@]}" --version >/dev/null 2>/dev/null \
|| req_cmd=(wget --auth-no-challenge --user="${OPTS[user]}" --password="${OPTS[pass]}" -qO -)

for h in ${csv_hosts}; do
  result="$("${req_cmd[@]}" "${API_URL}&host=${h}")" \
  && log_info "(${h}) ${result}" \
  || log_warn "(${h}) ${result}"
done
