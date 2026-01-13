FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    python3 \
    python3-pip \
    python3-dev \
    git \
    wget \
    libopenblas-dev \
    liblapack-dev \
    openmpi-bin \
    libopenmpi-dev \
 && rm -rf /var/lib/apt/lists/*

# ---- Python deps ----
RUN pip3 install --no-cache-dir \
    numpy \
    scipy \
    cython \
    mpi4py

# ---- CLASS ----
WORKDIR /opt
RUN git clone https://github.com/lesgourg/class_public.git class
WORKDIR /opt/class
RUN make -j2

ENV CLASS_PATH=/opt/class

# ---- MontePython ----
WORKDIR /opt
RUN git clone https://github.com/brinckmann/montepython_public.git montepython

ENV PYTHONPATH=/opt/montepython:/opt/class

WORKDIR /work