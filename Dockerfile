FROM rwehbe/deepcovidxr:large

SHELL ["/bin/bash", "-c"]

VOLUME ['/output']

ENTRYPOINT ["/bin/bash", "/home/deepcovidxr/deep_covid_xr_rumc/entrypoint.sh"]

RUN groupadd --system deepcovidxr && \
    useradd --system --shell /bin/bash --gid deepcovidxr deepcovidxr && \
    (echo deepcovidxr ; echo deepcovidxr) | passwd deepcovidxr

RUN mkdir -p /home/deepcovidxr/deep_covid_xr_rumc
RUN mkdir -p /home/deepcovidxr/deep_covid_xr_rumc_data

COPY docker_data/covid_weights /home/deepcovidxr/deep_covid_xr_rumc_data/covid_weights/
COPY docker_data/input_images /home/deepcovidxr/deep_covid_xr_rumc_data/input_images/
COPY docker_data/trained_unet_model.hdf5 /home/deepcovidxr/deep_covid_xr_rumc/

WORKDIR /home/deepcovidxr/deep_covid_xr_rumc

COPY covid_models covid_models/
COPY gradCAM_img gradCAM_img/
COPY img img/
COPY NIH NIH/
COPY sample_images sample_images/
COPY utils utils/

COPY crop_img.py \
     ensemble.py \
     ensemble_weights.pickle \
     entrypoint.sh \
     evaluate.py \
     predict.py \
     pretrain.py \
     resize_img.py \
     train.py \
     tuner.py \
     visSample.py \
     LICENSE \
     README.md \
     /home/deepcovidxr/deep_covid_xr_rumc/

RUN chown -R deepcovidxr:deepcovidxr /home/deepcovidxr
USER deepcovidxr
RUN lsb_release -a && python --version
