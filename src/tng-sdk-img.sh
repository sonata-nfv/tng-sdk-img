#!/bin/bash

EXEC="${0}"
VERSION=0.1
APP_DIR="/opt/tng-sdk-img"
TOOLS=$(ls "${APP_DIR}" 2> /dev/null)

function print_help() {
  echo "Usage:"
  echo -e "\t${EXEC} TOOL_NAME [OPTIONS]"
  echo -e "\t${EXEC} --help    \t\tShow this message"
  echo -e "\t${EXEC} --tools   \t\tList available tools"
  echo -e "\t${EXEC} --version \t\tPrint version"
}

function print_tools() {
  if [[ -z "${TOOLS}" ]]; then
    print_install_error
  else
    echo "Available tools:"
    echo "${TOOLS}"
  fi
}

function print_version() {
  echo "${VERSION}"
}

function print_install_error() {
  echo "ERROR: Can't find the directory with tools."
  echo "The directory is expected to be in ${APP_DIR}."
  echo "Try to reinstall the application or write to author."
}

function run_tool() {
  local tool_name="${1}"
  local tool="${APP_DIR}/${TOOL_NAME}/${TOOL_NAME}"
  
  if [ ! -f "${tool}" ]; then
    echo "ERROR: Tool \"${tool_name}\" is not found."
    exit 1
  fi
  
  shift
  exec "${tool}" "${@}"
}

function main() {
  if [[ ! -d "${APP_DIR}" ]]; then
    print_install_error
    exit 1
  fi
  
  if [[ "${#}" -lt 1 ]]; then
    echo "ERROR: Missing parameters."
    print_help
    exit 1
  fi
  
  while [[ "${#}" -gt 0 ]]; do
    case ${1} in
      -h|--help)
        print_help
        exit 0
        ;;
      -v|--version)
        print_version
        exit 0
        ;;
      -t|--tools)
        print_tools
        exit 0
        ;;
      *)
        run_tool "${@}"
        ;;
    esac
  done
}

main "${@}"
