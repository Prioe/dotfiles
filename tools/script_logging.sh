# detect color support on stderr, allow override with NO_COLOR
if [ -t 2 ] && [ -z "${NO_COLOR-}" ] && [ "${TERM-}" != "dumb" ] && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  ANSI_RESET='\033[0m'
  ANSI_DIM='\033[2m'
  ANSI_INFO='\033[1;32m'
  ANSI_WARN='\033[1;33m'
  ANSI_ERROR='\033[1;31m'
  ANSI_DEBUG='\033[1;36m'
else
  ANSI_RESET=''
  ANSI_DIM=''
  ANSI_INFO=''
  ANSI_WARN=''
  ANSI_ERROR=''
  ANSI_DEBUG=''
fi

info() { printf "%b %s\n" "${ANSI_INFO}::${ANSI_RESET}" "$@" >&2; }
warn() { printf "%b %s\n" "${ANSI_WARN}::${ANSI_RESET}" "$@" >&2; }
error() { printf "%b %s\n" "${ANSI_ERROR}::${ANSI_RESET}" "$@" >&2; }
debug() {
  if [[ -n "${DEBUG:-}" ]]; then
    printf "%b ${ANSI_DIM}%s${ANSI_RESET}\n" "${ANSI_DEBUG}::${ANSI_RESET}" "$@" >&2
  fi
}

script_name() {
  local base name
  base=${0##*/}
  name=${base#*.}
  printf '%s' "$name"
}

script_start() {
  info "Starting script: $(script_name)"
}

script_end() {
  info "Script completed: $(script_name)"
}
