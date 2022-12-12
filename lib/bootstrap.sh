LIB_DIR="${TOOL_DIR}/lib"
OPTS_DIR="${LIB_DIR}/opts"
HELP_DIR="${LIB_DIR}/help"

# common help
. "${HELP_DIR}/base.sh"
# provider help
. "${HELP_DIR}/${DDNS_PROVIDER}.sh"

# load functions
. "${LIB_DIR}/shlib.sh"

trap_help_opt "${@}" && print_help && exit

# common options
. "${OPTS_DIR}/base.sh"
# provider options
. "${OPTS_DIR}/${DDNS_PROVIDER}.sh"

mkopts "${@}"

fail_on_inval_opts "${OPTS[inval]}" || exit 1

validate_req_opts || exit 1
