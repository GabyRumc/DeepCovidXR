#!/bin/bash -e

docker_image="doduo1.umcn.nl/gabyvansoest/deep-covid-xr-rumc:latest"
base_dir="/home/gabyvs"
input_dir="${base_dir}/cxr-deep-covid-xr_t9463/Open-I_5/images"
output_dir="${base_dir}/results/Open-I_5"
nvsmi=$(which nvidia-smi)

# docker run -v "${input_dir}:/input:ro" -v "${output_dir}:/output" --runtime=nvidia "${docker_image}"
[[ -d "${input_dir}" ]] || (echo "\"S{input_dir}\" is not a directory"; exit 1)
[[ -d "${output_dir}" ]] || mkdir -p "${output_dir}"
# ensure output is world-writable
chmod 777 "${output_dir}"

if [[ -n "${nvsmi}" ]] && ${nvsmi} ;
then
    nvrun="--runtime=nvidia"
else
    nvrun=""
fi

docker run -v "${input_dir}:/input:ro" -v "${output_dir}:/output" ${nvrun} "${docker_image}"

