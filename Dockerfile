# Use Base Debian Bullseye slim image
FROM debian:bullseye-slim

# Author of this Dockerfile
LABEL org.opencontainers.image.authors="marko[AT]aretaja.org"

# Update and install slapd
RUN apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get -yqq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -yqq install \
    slapd \
    ldap-utils \
    smbldap-tools && \
 DEBIAN_FRONTEND=noninteractive apt-get -yqq autoremove && \
 apt-get -qq clean && \
 rm -rf /var/lib/apt/lists/*

# Default env variables
ENV DEBUGSLAPD=Stats
ENV CONFIMPORT=0

# Start script
WORKDIR /home/slapd
RUN mkdir bin config certs import export
ADD --chown=root:root --chmod=0770 files/start.sh bin/
ADD --chown=root:root --chmod=0770 files/backup.sh bin/

EXPOSE 389/tcp 636/tcp

ENTRYPOINT [ "./bin/start.sh" ]

