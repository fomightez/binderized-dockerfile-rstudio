FROM rocker/verse:3.3.1
LABEL maintainer "Wayne Decatur *(fomightez on Github)*"

ENV NB_USER rstudio
ENV NB_UID 1000
ENV VENV_DIR /srv/venv

# Set ENV for all programs...
ENV PATH ${VENV_DIR}/bin:$PATH
# And set ENV for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib

ENV HOME /home/${NB_USER}
WORKDIR ${HOME}

RUN apt-get update && \
    apt-get -y install python3-venv python3-dev && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a venv dir owned by unprivileged user & set up notebook in it
# This allows non-root to install python libraries if required
RUN mkdir -p ${VENV_DIR} && chown -R ${NB_USER} ${VENV_DIR}

USER ${NB_USER}
RUN python3 -m venv ${VENV_DIR} && \
    pip3 install --no-cache-dir \
         notebook==5.2 \
         git+https://github.com/jupyterhub/nbrsessionproxy.git@6eefeac11cbe82432d026f41a3341525a22d6a0b \
         git+https://github.com/jupyterhub/nbserverproxy.git@5508a182b2144d29824652d8977b32302517c8bc && \
    jupyter serverextension enable --sys-prefix --py nbserverproxy && \
    jupyter serverextension enable --sys-prefix --py nbrsessionproxy && \
    jupyter nbextension install    --sys-prefix --py nbrsessionproxy && \
    jupyter nbextension enable     --sys-prefix --py nbrsessionproxy


RUN R --quiet -e "devtools::install_github('IRkernel/IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${VENV_DIR}')"


CMD jupyter notebook --ip 0.0.0.0


## If extending this image, remember to switch back to USER root to apt-get
    
# Copy repo into ${HOME}, make user own $HOME
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
USER ${NB_USER}

## run any install.R script we find
RUN if [ -f install.R ]; then R --quiet -f install.R; fi


# This is a combination of parts of:
# https://hub.docker.com/r/rocker/geospatial/~/dockerfile/
# https://github.com/rocker-org/binder/blob/master/3.4.2/Dockerfile 
# https://github.com/binder-examples/dockerfile-rstudio/blob/master/Dockerfile
# in that order to do much of what binder-examples/dockerfile-rstudio
# does in approach. However, here, instead of incorporating geospatial items
# that could potentialy pollute the namespaces (I think R calls environment vaiables?)
# I used the approach of https://github.com/taylorreiter/dockerfile-r that was forked from https://github.com/binder-examples/dockerfile-r 
# (discovered it in the network diagram of the forked repos when `rna-seq` in the tags caught my eye)
# to add an `install.R` file and install my favorite packages from bioconductor.
