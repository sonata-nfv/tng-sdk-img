#!/bin/bash

EXEC="${0}"
VERSION="0.1"
PLATFORM="sonata"

function die() {
  echo "${@}"
  echo "Try '${EXEC} --help' for more information."
  exit 1
}

function print_help() {
  echo "Usage:"
  echo -e "\t${EXEC} [OPTIONS] VNFD"
  echo "Options:"
  echo -e "--help"
  echo -e "--version"
  echo -e "--platform   \tTarget platform - sonata (default) or tango"
  echo -e "--base-image \tPath to the base image. Ubuntu 16.04 cloud image will be downloaded to /tmp if not specified."
}

function check_requirements() {
  echo "Checking requirements"
  local commands=(wget cloud-localds kvm shyaml curl)
  for command in "${commands[@]}"; do
    command -v "${command}" &> /dev/null
    [[ ${?} -eq 0 ]] || die "${command} not found"
  done
  echo "OK"
}

function create_seed() {
  echo "Creating seed"
  seed_image=$(mktemp --suffix converter)
  local user_data=$(mktemp --suffix converter)
  local udev_rules_file=$(mktemp --suffix converter)

  IFS=', ' read -r -a array <<< "${vdu_interfaces}";
  for index in "${!array[@]}"; do
    echo "KERNEL==\"e*\" SUBSYSTEM==\"net\" ATTRS{ifindex}==\"$((index+2))\" NAME=\"${array[index]}\"" >> "${udev_rules_file}"
  done

  local vnf_container_service=$(cat vnf-container.service | sed "s/^/    /")
  local netplug=$(cat netplug | sed "s/^/    /")
  local vdu_interfaces=$(echo "${vdu_interfaces}" | xargs -n1 | sed "s/^/    /")
  local udev_rules=$(cat ${udev_rules_file} | sed "s/^/    /")

  eval "cat << EOF > "${user_data}"
$(<user-data.template)
  EOF
  " 2> /dev/null

  cloud-localds "${seed_image}" "${user_data}"

  rm -f "${user_data}"
  rm -f "${udev_rules_file}"
  echo "OK"
}

function delete_seed() {
  echo "Deleting seed"
  rm -f "${seed_image}"
  echo "OK"
}

function get_base_image() {
  [[ ! $base_image_specified ]] || return 0
  echo "Downloading base image"
  base_image=$(mktemp --suffix converter)
  local image_url="http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img"
  wget "${image_url}" -O "${base_image}" -q --show-progress
  echo "OK"
}

function delete_base_image() {
  [[ ! $base_image_specified ]] || return 0
  echo "Deleting base image"
  rm -f "${base_image}"
  echo "OK"
}

function create_vdu() {
  echo "Creating VDU"
  local vm_file="${vnf_name}_${vdu_id}.qcow2"
  cp "${base_image}" "${vm_file}"
  kvm -display none -m 1024 -cdrom "${seed_image}" "${vm_file}" &
  local kvm_pid="${!}"
  while ps -p "${kvm_pid}" > /dev/null; do
   echo -n "."
   sleep 1
  done
  echo
  echo "OK"
}

function docker_image_exists() {
  local docker_image=(${1//:/ })
  local name="${docker_image[0]}"
  local tag="${docker_image[1]}"
  [[ -n "${tag}" ]] || tag="latest"
  curl --silent -f -lSL https://index.docker.io/v1/repositories/"${name}"/tags/"${tag}" &> /dev/null;
  return "${?}"
}


function convert() {
  echo "Starting conversion"
  vnf_name=$(cat "${vnfd}" | shyaml get-value name)
  echo $vnf_name

  # Extract VDUs from descriptor and save them to temporary directory
  vdu_dir=`mktemp -d --suffix converter`
  cat "${vnfd}" | shyaml get-values virtual_deployment_units | head -n -1 | csplit -zs -f "${vdu_dir}"/ - /^$/ {*}

  for vdu in "${vdu_dir}"/*; do
    vdu_id=$(cat "${vdu}" | shyaml get-value id)
    vdu_format=$(cat "${vdu}" | shyaml get-value vm_image_format)
    vdu_image=$(cat "${vdu}" | shyaml get-value vm_image)
    vdu_interfaces=$(cat "${vdu}" | shyaml get-value connection_points | grep id | cut -d ' ' -f 3 | xargs)

    echo "Processing ${vdu_id}"

    if [ "${vdu_format}" != "docker" ]; then
      echo "WARNING: 'vm_image_format' is not docker. Skipping"
      continue
    fi

    if ! docker_image_exists "${vdu_image}"; then
      echo "WARNING: Docker image '${vdu_image}' does not exist in Docker Hub. Skipping"
      continue
    fi

    create_seed
    create_vdu
    delete_seed
  done

  rm -rf "${vdu_dir}"
  echo "Conversion finished."
}

function main() {
  if [[ ${#} -lt 1 ]]; then
    die "ERROR: VNFD is not specified."
    exit 1
  fi

  while [[ ${#} -gt 0 ]]; do
    case "${1}" in
      -h|--help)
        print_help
        exit 0
        ;;
      -v|--version)
        print_version
        exit 0
        ;;
      -p|--platform)
        [[ -n "${2}" ]] || die "ERROR: Target platform is not specified."
        PLATFORM="${2}"
        shift 2
        ;;
      -b|--base-image)
        [[ -n "${2}" ]] || die "ERROR: Base image is not specified."
        base_image="${2}"
        base_image_specified=true
        shift 2
        ;;
      *)
        [[ -z "${vnfd}" ]] || die "ERROR: Too much arguments."
        vnfd="${1}"
        shift
        ;;
    esac
  done
  
  [[ -n "${vnfd}" ]] || die "ERROR: VNFD is not specified."
  [[ -f "${vnfd}" ]] || die "ERROR: File ${vnfd} does not exist."
  [[ -n "${base_image}" ]] || base_image_specified=false

  check_requirements
  get_base_image
  convert
  delete_base_image
}

main "${@}"

