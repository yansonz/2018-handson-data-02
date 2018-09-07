FROM ubuntu:16.04

MAINTAINER Amazon SageMaker Examples <amazon-sagemaker-examples@amazon.com>

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    wget \
    r-base \
    r-base-dev \
    ca-certificates \
    python2.7 \
    python2.7-dev \
    python-pip \
    python-dev \
    python-virtualenv \
    git \
    vim \
    curl
    
RUN apt-get install -y --no-install-recommends libssl-dev \
        libssh2-1-dev \
        libcurl4-openssl-dev \
        libcairo2-dev \
        libxt-dev \
        libfftw3-dev \
        libtiff5-dev \
        libxml2-dev

RUN pip install boto3
RUN pip install Pillow numpy scipy
RUN pip install --upgrade virtualenv
RUN pip install opencv-python
RUN pip install argparse
RUN pip install setuptools
RUN pip install openapi-codec

RUN R -e "install.packages(c('devtools', 'plumber', 'jsonlite', 'base64enc', 'uuid', 'readbitmap'), repos='https://cloud.r-project.org')"
RUN R -e "install.packages(c('Cairo', 'rPython', 'imager', 'aws.signature', 'aws.s3', 'googleAuthR', 'sp'), repos='https://cloud.r-project.org')"
RUN R -e "install.packages(c('tree', 'colorspace'), repos='https://cloud.r-project.org')"

COPY credentials /opt/ml/credentials
COPY serve.R /opt/ml/serve.R
COPY plumber.R /opt/ml/plumber.R

ENTRYPOINT ["/usr/bin/Rscript", "/opt/ml/serve.R", "--no-save"]