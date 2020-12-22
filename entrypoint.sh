#!/bin/bash -e

data_dir="/home/deepcovidxr/deep_covid_xr_rumc_data"
input_dir="${data_dir}/input_images"
weights_dir="${data_dir}/covid_weights"
working_dir="/home/deepcovidxr/deep_covid_xr_rumc"
log_file="/output/open-cxr14_log.txt"

export PYTHONPATH="${working_dir};${working_dir}/utils"

cd "${working_dir}"

python3 predict.py -w "${weights_dir}" -i "${input_dir}" -o /output | tee --append "${log_file}" 2>&1
for d in 224 331 crop crop_squared; do
  cp -r "${data_dir}/${d}" /output
done
