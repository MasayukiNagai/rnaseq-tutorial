# Start from a base image that supports ARM64
FROM ubuntu:20.04

# Set the environment variable to make sure it is non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends\
    bash \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    mercurial \
    subversion \
    vim

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install Miniforge
WORKDIR /usr/src/
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash ./Miniforge3-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniforge3-Linux-x86_64.sh

# Add conda to the path
ENV PATH=/opt/conda/bin:$PATH

# Use Miniforge to install Python and any other dependencies
RUN conda install -y python=3

# Continue with any other commands you need for your setup
# Initialize conda in bash config
RUN conda init bash
RUN  . /root/.bashrc

# Install Snakemake using mamba
RUN mamba install -c conda-forge -c bioconda snakemake

# Set up the conda environment to emulate linux-64 if necessary
RUN conda config --env --set subdir linux-64

# Get the rnaseq-tutorial repository 
RUN git clone https://github.com/meyer-lab-cshl/rnaseq-tutorial.git
WORKDIR /usr/src/rnaseq-tutorial