# Dockerfile: builds CLASS and provides CI-ready image that can run alive check
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# ----- system packages -----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    python3 \
    python3-pip \
    python3-dev \
    git \
    wget \
    ca-certificates \
    libopenblas-dev \
    liblapack-dev \
 && rm -rf /var/lib/apt/lists/*

# ----- clone and build CLASS -----
WORKDIR /opt
RUN git clone https://github.com/lesgourg/class_public.git class

WORKDIR /opt/class
# Build CLASS; -j2 to be conservative in CI
RUN make -j2

ENV CLASS_PATH=/opt/class
ENV PATH=$CLASS_PATH:$PATH

# ----- copy repo files (CI will mount workdir or use image directly) -----
WORKDIR /work
COPY . /work
RUN chmod +x /work/scripts/alive_check.sh

# default entrypoint (useful for local docker run)
ENTRYPOINT ["/work/scripts/alive_check.sh"]