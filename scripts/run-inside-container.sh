#!/bin/bash

set -euo pipefail

# Example: IAAS_TO_REMOVE="vsphere gcp azure openstack"
[ -z "${IAAS_TO_REMOVE:-}" ] && echo '$IAAS_TO_REMOVE must be set' && exit 2

python_package_dir=/rootfs/usr/local/lib/python3.*/dist-packages

for iaas in ${IAAS_TO_REMOVE}
do
  case $iaas in
    aws)
      rm -rf ${python_package_dir}/awscli
      rm -rf ${python_package_dir}/botocore
      rm /usr/local/bin/aws
      ;;
    azure)
      rm -rf ${python_package_dir}/azure*
      rm /usr/local/bin/az
      ;;
    gcp)
      gcloud_dir=`gcloud info --format='value(installation.sdk_root)'`
      gcloud_config_dir=`gcloud info --format='value(config.paths.global_config_dir)'`
      rm -rf $gcloud_dir
      rm -rf $gcloud_config_dir
      ;;
    openstack)
      pip uninstall openstacksdk python-keystoneclient python-novaclient python-cinderclient -y
      rm -rf ${python_package_dir}/python_*
      rm /usr/local/bin/openstack
      ;;
    vsphere)
      rm /usr/bin/govc
      ;;
    # *)
    #   echo "IaaS type ${iaas} is not recognised"
    #   echo "Valid options are:'aws, azure, gcp, vsphere'"
    #   exit 1
    #   ;;
  esac
done

