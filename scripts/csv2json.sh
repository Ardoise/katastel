#!/usr/bin/env bash
#
# chkconfig: 2345 20 80
# description: Logstash csv to Json
#

SCRIPT_DIR=$(dirname "$0")
SCRIPT_NAME=$(basename "$0")
KATASTEL_HOME=$(cd "${SCRIPT_DIR}" && cd .. && pwd)
PROGNAME=$(basename "$0")

warn() { echo "${PROGNAME}: $*"; }
die() { warn "$*"; exit 1 }

init() {
  ##;
}
run() {
  LOGSTASH_INPUTS_DIR="${KATASTEL_HOME}/input";
  LOGSTASH_OUTPUTS_DIR="${KATASTEL_HOME}/output";
  LOGSTASH_PROCESS_DIR="${KATASTEL_HOME}/process";
  ##;
}
main() {
  init "$1";
  run "$@";
}

case "$1" in
  start)
    main "$@"
    ;;
  restart)
    init
    run "stop"
    run "start"
  ;;
  *)
    echo "Usage csv2json {start|run}"
    ;;
esac