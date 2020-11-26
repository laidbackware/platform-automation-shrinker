# platform-automation-shrinker

Shrink the VMware Tanzu Platform Automation Toolkit base image buy removing cloud provider binaries. This has been tested on version 5.0.9 which is the first version without p-automator.

## Usage
- Import the platform automation image from pivnet into docker, providing a label and tag.
- Export env vars containing the imported image tags and list of IaaS platforms to remove.<br/>
  Supported values are `aws azure gcp openstack vsphere`, leaving the provider you need.
```
docker import platform-automation-image-5.0.9.tgz "platform-automation:5.0.9"
export SOURCE_IMAGE_TAG=platform-automation:5.0.9
export IAAS_TO_REMOVE="azure gcp openstack vsphere"
./shrink.sh
```
After completion `docker image list` will show the existing image and a new image with `-shinny` appended to the tag.<br/>
In the repo directory there will be a file containing the inital take (without the : symnbol) appended with -skinny. E.g. `platform-automation-5.0.9-skinny.tgz`.<br/>
The output file name/location can be overrode but exporting a custom value. E.g. `export OUTPUT_FILE=/tmp/export.tgz`