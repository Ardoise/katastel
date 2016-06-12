#!/usr/bin/env bash
#
# chkconfig: 2345 20 80
# description: Logstash csv to Json
#

SCRIPT_DIR=$(dirname "$0");
SCRIPT_NAME=$(basename "$0");
KATASTEL_HOME=$(cd "${SCRIPT_DIR}" && cd .. && pwd);
KATASTEL_TMP_DIR=/tmp/katastel/;
PROGNAME=$(basename "$0");

warn() { echo "${PROGNAME}: $*"; }
die() { warn "$*"; exit 1; }

init() {
  if [ -f ${KATASTEL_HOME}/lib/katastel ]; then
    source ${KATASTEL_HOME}/lib/katastel;
  else
    die "${KATASTEL_HOME}/lib/katastel unknow";
  fi
  [ -d ${KATASTEL_TMP_DIR} ] || (mkdir -p ${KATASTEL_TMP_DIR});
}
run() {
  LOGSTASH_INPUT_DIR="${KATASTEL_HOME}/input";
  LOGSTASH_FILTER_DIR="${KATASTEL_HOME}/filter";
  LOGSTASH_OUTPUT_DIR="${KATASTEL_HOME}/output";
  LOGSTASH_PROCESS_DIR="${KATASTEL_HOME}/process";

  set |grep "^input";

    echo "input {" >${KATASTEL_TMP_DIR}file.conf;
  cat ${LOGSTASH_INPUT_DIR}/file.tmpl |sed -e "s~inputfilepath~${inputfilepath}~g" -e 's~^~  ~' >>${KATASTEL_TMP_DIR}file.conf;
    echo -e "\n}" >>${KATASTEL_TMP_DIR}file.conf;
    echo -e "filter {" >>${KATASTEL_TMP_DIR}file.conf;
  #cat ${LOGSTASH_FILTER_DIR}/grep.tmpl |sed -e 's~^~  ~' >>${KATASTEL_TMP_DIR}file.conf;
  #  echo "" >>${KATASTEL_TMP_DIR}file.conf;
  cat ${LOGSTASH_FILTER_DIR}/csv.tmpl |sed -e "s~filterfilepath~${inputfilepath}~g" -e 's~^~  ~' >>${KATASTEL_TMP_DIR}file.conf;
    echo -e "\n}" >>${KATASTEL_TMP_DIR}file.conf;
    echo -e "output {" >>${KATASTEL_TMP_DIR}file.conf;
    echo -e "  stdout{}" >>${KATASTEL_TMP_DIR}file.conf;
  cat ${LOGSTASH_OUTPUT_DIR}/elasticsearch.tmpl |sed -e "s~127.0.0.1~${outputelasticsearchhost}~g" -e 's~^~  ~' >>${KATASTEL_TMP_DIR}file.conf;
    echo -e "\n}" >>${KATASTEL_TMP_DIR}file.conf;
  cat ${KATASTEL_TMP_DIR}file.conf;

  echo "/opt/logstash/bin/logstash -f ${KATASTEL_TMP_DIR}file.conf" >${KATASTEL_TMP_DIR}file.run
  cat ${KATASTEL_TMP_DIR}file.run;

}
main() {
  init "$1";
  run "$@";
}

case "$1" in
  start)
    main "$@";
    ;;
  restart)
    init;
    run "stop";
    run "start";
    ;;
  *)
    echo "Usage csv2json {start|restart}";
    ;;
esac
