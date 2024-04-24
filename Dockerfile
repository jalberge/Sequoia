FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# build essentials and git
RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	gnupg \
	gfortran \
        libblas-dev \
        liblapack-dev \
        libz-dev \
	libssl-dev \
	libfontconfig1-dev \
	libcurl4-openssl-dev \
	libxml2-dev \
	libharfbuzz-dev \ 
	libfribidi-dev \
	libfreetype6-dev \
	libpng-dev \
	libtiff5-dev \
	libjpeg-dev \
	git \
	wget
# R
RUN apt install -y --no-install-recommends software-properties-common dirmngr \
	&& wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
	&& add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
        r-base \
	r-base-dev \
	&& rm -rf /var/lib/apt/lists/*
#MPBoot library
WORKDIR /app
RUN wget http://www.iqtree.org/mpboot/mpboot-avx-1.1.0-Linux.tar.gz \
	&& tar -xvzf mpboot-avx-1.1.0-Linux.tar.gz \
	&& cd mpboot-avx-1.1.0-Linux/bin \
	&& ln -s mpboot-avx mpboot
#install packages
RUN git clone https://github.com/jalberge/Sequoia.git \
	&& cd Sequoia \
	&& Rscript build_phylogeny.R -r PD45567_NR.tsv -v PD45567_NV.tsv --mpboot_path ../mpboot-avx-1.1.0-Linux/bin/
