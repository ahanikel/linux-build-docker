FROM linux-builder-base:1.0.0
COPY build-u-boot-internal /
COPY build-linux-internal /
COPY build-e2fsprogs-internal /
COPY build-initramfs-internal /
COPY boot.cmd /
COPY initramfs-init /
RUN (cd /u-boot && git pull origin master)
RUN (cd /linux && git pull origin master)
RUN (cd /e2fsprogs && git pull origin master)
RUN (cd /busybox && git pull origin master)
