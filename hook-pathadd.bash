[[ -n "${BASH_VERSION}" ]] && {
  __iife() {
    unset __iife
    local projdir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    [[ "$(type -t pathadd.append)" != 'function' ]] && return

    DDNS_BINDIR="${DDNS_BINDIR:-${projdir}/bin}"
    [[ -z "$(bash -c 'echo ${DDNS_BINDIR+x}')" ]] \
      && export DDNS_BINDIR

    pathadd.append "${DDNS_BINDIR}"
  } && __iife
}
