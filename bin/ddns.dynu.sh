#!/usr/bin/env bash

# https://www.dynu.com/DynamicDNS/IP-Update-Protocol

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://api.dynu.com/nic/update?"
DDNS_PROVIDER="dynu"
MIN_UPDATE_INTERVAL=5
IP_PROVIDER=""

. "${TOOL_DIR}/lib/bootstrap.sh"

LOG_TOOLNAME=dynu

[[ -n "${OPTS[ip]}" ]] && {
  API_URL+="&myip=${OPTS[ip]}"
} || {
  OPTS[ip]="$(get_current_ip)"
}
[[ -z "${OPTS[ip]}" ]] && OPTS[ip]="NOT_DETECTED"

declare -a req_cmd=(curl -ks --basic -u "${OPTS[user]}:${OPTS[pass]}")
"${req_cmd[@]}" --version >/dev/null 2>/dev/null \
|| req_cmd=(wget --auth-no-challenge --user="${OPTS[user]}" --password="${OPTS[pass]}" -qO -)

log_info "IP: ${OPTS[ip]}"

[[ -z "${OPTS[hosts]}" ]] && {
  result="$("${req_cmd[@]}" "${API_URL}")" \
  && log_info "(all) ${result}" \
  || log_warn "(all) ${result}"
  exit
}

# convert from newline and comma separated
# to space separated
csv_hosts="$(
  tr ',' '\n' <<< "${OPTS[hosts]}" | grep -vFx '' \
  | tr '\n' ' '
)"

for h in ${csv_hosts}; do
  result="$("${req_cmd[@]}" "${API_URL}&hostname=${h}")" \
  && log_info "(${h}) ${result}" \
  || log_warn "(${h}) ${result}"
done
