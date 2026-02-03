FROM linux-builder-base:1.0.0
COPY build-u-boot-internal /
COPY build-linux-internal /
COPY build-initramfs-internal /
COPY boot.cmd /
RUN (cd /u-boot && git pull origin master && git fetch --tags)
RUN (cd /linux && git pull origin master && git fetch --tags)
RUN (cd /busybox && git pull origin master && git fetch --tags)
