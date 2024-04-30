ARG BASEIMAGE=docker.io/library/debian:12
FROM ${BASEIMAGE}

# install grub build dependencies
RUN set -x \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git python3 build-essential gawk gettext bison flex pkg-config autoconf automake autopoint \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /opt \
    && cd /opt \
    && git clone --filter=tree:0 --no-checkout https://git.savannah.gnu.org/git/grub.git
    
# GRUB Git ref (tag, or commit sha)
ARG GRUB_REF=grub-2.12
# checking out the grub version
RUN set -x \
    && cd /opt/grub \
    && git checkout ${GRUB_REF} \
    && ./bootstrap \
    && ./configure --with-platform=efi
# now build and install it skipping make check
RUN set -x \
    && cd /opt/grub \
    && make \
    && make install \
    && make clean