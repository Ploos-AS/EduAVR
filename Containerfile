FROM debian:bookworm

LABEL org.opencontainers.image.title="EduAVR development environment"
LABEL org.opencontainers.image.description="Open AVR toolchain and simavr environment for the EduAVR course"
LABEL org.opencontainers.image.source="https://github.com/Ploos-AS/EduAVR"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="Ploos AS"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      make \
      gcc \
      gcc-avr \
      binutils-avr \
      avr-libc \
      avrdude \
      avarice \
      gdb-avr \
      simavr \
      libsimavr-dev \
      libelf-dev \
      coreutils \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["/bin/bash"]
