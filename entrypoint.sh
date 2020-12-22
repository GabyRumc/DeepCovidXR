#!/bin/bash -e

data_dir="/home/deepcovidxr/deep_covid_xr_rumc_data"
weights_dir="${data_dir}/covid_weights"
preproc_root="/output/preproc"
predicted_output="/output/predicted"
working_dir="/home/deepcovidxr/deep_covid_xr_rumc"
log_file="/output/open-i_5_log.txt"

export PYTHONPATH="${working_dir};${working_dir}/utils"

cd "${working_dir}"

[[ -d "${preproc_root}" ]] || mkdir -p "${preproc_root}"
[[ -d "${predicted_output}" ]] || mkdir -p "${predicted_output}"

for d in 000 001 002 003 004 ; 
do
    preproc_out="${preproc_root}/${d}"
    pred_out="${predicted_output}/${d}"
    for processed in 224 331 crop crop_squared
    do
        proc_dir="${preproc_out}/${processed}"
        [[ -d "${proc_dir}" ]] && rm -rf "${proc_dir}"
    done
    [[ -d "${preproc_out}" ]] || mkdir -p "${preproc_out}"
    [[ -d "${pred_out}" ]] || mkdir -p "${pred_out}"
    # python3 predict.py -w "${weights_dir}" -i "/input/${d}" -p "${preproc_out}" -o "${pred_out}" | tee --append "${log_file}" 2>&1
done
python3 predict.py -w "${weights_dir}" -i "/input/" -p "${preproc_root}" -o "${predicted_output}" | tee --append "${log_file}" 2>&1

