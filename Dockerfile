FROM linux-builder-base:1.0.0
COPY build-linux-internal /
COPY build-initramfs-internal /
COPY mkimage /
COPY boot.cmd /
RUN (cd /linux && git pull origin master && git fetch --tags)
RUN (cd /busybox && git pull origin master && git fetch --tags)
