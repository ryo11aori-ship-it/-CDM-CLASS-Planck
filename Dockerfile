FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    timeout \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work

COPY . /work

RUN make -C class
RUN chmod +x /work/scripts/alive_check.sh

ENTRYPOINT ["/work/scripts/alive_check.sh"]