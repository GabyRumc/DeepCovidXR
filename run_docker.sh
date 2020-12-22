#!/bin/bash -e

[[ -z ${1} ]] && echo "please supply cmdline arg for full path to output dir"; exit 1
output_dir="${1}"

docker_image="doduo1.umcn.nl/gabyvansoest/deep-covid-xr:latest"
nvsmi=$(which nvidia-smi)

# docker run -v "${output_dir}:/output" --runtime=nvidia "${docker_image}"
[[ -d "${output_dir}" ]] || mkdir -p "${output_dir}"
# ensure output is world-writable
chmod 777 "${output_dir}"

if [[ -n "${nvsmi}" ]] && ${nvsmi} ;
then
    nvrun="--runtime=nvidia"
else
    nvrun=""
fi

docker run -v "${output_dir}:/output" ${nvrun} "${docker_image}"
