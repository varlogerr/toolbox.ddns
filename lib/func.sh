mkopts() {
  local eopt=0
  local opt
  local optname

  while :; do
    [[ -z "${1+x}" ]] && break
    opt="${1}"; shift

    [[ (${eopt} -eq 1 || "${opt:0:1}" != '-' ) ]] && {
      OPTS[hosts]+="${OPTS[hosts]:+ }${opt}"
      continue
    }

    optname=''
    case "${opt}" in
      -u|--user|--user=?*)  optname=user ;;
      -p|--pass|--pass=?*)  optname=pass ;;
      -i|--ip|--ip=?*)      optname=ip ;;
      --)   eopt=1; continue ;;
    esac

    [[ (-z "${optname}" || -z "${OPTS[${optname}]+x}") ]] && {
      OPTS[inval]+="${OPTS[inval]:+$'\n'}${opt}"
      continue
    }

    [[ "${opt}" == *'='* ]] && {
      OPTS[${optname}]="${opt#*=}"
    } || {
      OPTS[${optname}]="${1}"
      shift
    }
  done
}

fail_on_inval_opts() {
  [[ -z "${1}" ]] && return 0

  echo "Invalid optsions" >&2
  while read -r o; do
    [[ -n "${o}" ]] && echo "* ${o}"
  done <<< "${1}" >&2
  return 1
}

validate_req_opts() {
  local required_opts="$(
    tr ' ' '\n' <<< "${OPTS_REQUIRED}" \
    | grep -vFx ''
  )"
  local avail_opts="$(
    for k in "${!OPTS[@]}"; do
      [[ -z "${k}" ]] && continue
      [[ -n "${OPTS[$k]}" ]] && echo "${k}"
    done
  )"

  local missing="$(
    grep -vFx -e "${avail_opts}" <<< "${required_opts}"
  )"

  [[ -n "${missing}" ]] && {
    echo "Missing required parameters:"
    sed 's/^/* /g' <<< "${missing}"
    return 1
  }

  return 0
}

get_current_ip() {
  local ip_provider="${IP_PROVIDER:-https://ifconfig.me}"
  curl -fksL "${ip_provider}"
}

print_log() {
  local msg="${1}"
  local provider="${DDNS_PROVIDER:-unknown}"
  printf -- '[%s: %s] %s\n' \
    "${provider}" "$(get_ts)" "${msg}"
}

get_ts() {
  date +"%y-%m-%d %H:%M:%S"
}

detect_help() {
  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      -\?|-h|--help)  print_help; return 0 ;;
    esac

    shift
  done

  return 1
}

print_help() {
  grep -vx '\s*' <<< "${HELP_DESCRIPTION}" \
  | sed -E 's/^\s+//g'

  echo
  echo "Usage:"
  grep -vx '\s*' <<< "${HELP_USAGE}" \
  | sed -E 's/^\s+//g' | sed -E 's/^/  /g'


  echo
  echo "Available options:"
  grep -vx '\s*' <<< "${HELP_OPTS}" \
  | sed -E 's/^\s+//g' | sed -E 's/^/  /g'

  echo
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    Environment variables can be used
    instead of inline arguments.
    Supported environment variables:
  "
  grep -vx '\s*' <<< "${HELP_ENVVARS}" \
  | sed -E 's/^\s+//g' | sed -E 's/^/  * /g'

  echo
  echo "Demo:"
  grep -vx '\s*' <<< "${HELP_DEMO}" \
  | sed -E 's/^\s+//g' | sed -E 's/^/  /g'
}
