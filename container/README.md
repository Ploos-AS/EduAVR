# EduAVR development container

This directory defines the reference EduAVR student toolchain as an OCI image.

It is intentionally Debian-based and contains the same core tools used by the course:

- AVR-GCC
- GNU AVR Binutils
- AVR-LibC
- AVRDUDE
- GNU Make
- Git

The goal is that a student can clone EduAVR, start the container, and use the same compiler/toolchain as the course without installing an IDE or Arduino framework.

Example with Podman:

```sh
podman build -t eduavr-dev -f container/Containerfile .
podman run --rm -it -v "$PWD:/work" eduavr-dev
```

Docker can use the same OCI-compatible Containerfile:

```sh
docker build -t eduavr-dev -f container/Containerfile .
docker run --rm -it -v "$PWD:/work" eduavr-dev
```

Inside the container:

```sh
make check
```

USB/STK500 access is deliberately a separate concern. The container is first and foremost the reproducible build, inspect and learning environment.
