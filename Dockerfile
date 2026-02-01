FROM linux-builder-base:1.0.0
RUN apt-get update && apt-get install -y cpio && rm -rf /var/lib/apt/lists/*
COPY build-linux-internal .
COPY build-initramfs-internal .
RUN git pull origin master && git fetch --tags
