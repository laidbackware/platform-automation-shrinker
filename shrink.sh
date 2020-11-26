#!/bin/bash

set -exuo pipefail

[ -z "${SOURCE_IMAGE_TAG:-}" ] && echo '$SOURCE_IMAGE_TAG must be set' && exit 2
[ -z "${IAAS_TO_REMOVE:-}" ] && echo '$IAAS_TO_REMOVE must be set' \
  && echo "Valid space separated options are: 'aws azure gcp openstack vsphere'" && exit 2
export iaas_to_remove=${IAAS_TO_REMOVE}
export source_image_tag=${SOURCE_IMAGE_TAG}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

default_output="${SCRIPT_DIR}/${SOURCE_IMAGE_TAG/:/-}-skinny.tgz"
output_file=${OUTPUT_FILE:-${default_output}}

docker build --build-arg iaas_to_remove --build-arg source_image_tag . \
  -t platform-automation:to_export

echo -e "\nRunning container once to create export"
CONTAINER_SHA=$(docker run -d platform-automation:to_export ls)

echo -e "\nExporting container to ${output_file}"
docker export ${CONTAINER_SHA} |gzip > ${output_file}
echo -e "\nTidying up"
docker rm ${CONTAINER_SHA}
docker rmi platform-automation:to_export

echo -e "\nImporting smaller image as ${SOURCE_IMAGE_TAG}-skinny"
docker import ${output_file} "${SOURCE_IMAGE_TAG}-skinny"