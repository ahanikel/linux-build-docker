.PHONY: run stage clean

run:
	./run-uboot-linux

stage: output/u-boot.bin output/Image output/initramfs.cpio.gz output/boot.scr output/e2fsprogs.tar.gz output/alpine.tar.gz output/glibc.tar.gz output/sbcl.tar.gz
	./run-uboot-linux-stage --share .

clean:
	rm -rf output

output/base-image: Dockerfile-base
	mkdir -p output
	docker build -t base-image -f Dockerfile-base .
	touch output/base-image

output/u-boot-image: Dockerfile-u-boot build-u-boot-internal output/base-image
	docker build -t u-boot-image -f Dockerfile-u-boot .
	touch output/u-boot-image

output/linux-image: Dockerfile-linux output/base-image
	docker build -t linux-image -f Dockerfile-linux .
	touch output/linux-image

output/busybox-image: Dockerfile-busybox build-busybox-internal output/base-image
	docker build -t busybox-image -f Dockerfile-busybox .
	touch output/busybox-image

output/initramfs-image: Dockerfile-initramfs build-initramfs-internal output/base-image
	docker build -t initramfs-image -f Dockerfile-initramfs .
	touch output/initramfs-image

output/e2fsprogs-image: Dockerfile-e2fsprogs build-e2fsprogs-internal output/base-image
	docker build -t e2fsprogs-image -f Dockerfile-e2fsprogs .
	touch output/e2fsprogs-image

output/glibc-image: Dockerfile-glibc build-glibc-internal output/base-image
	docker build -t glibc-image -f Dockerfile-glibc .
	touch output/glibc-image

output/sbcl-image: Dockerfile-sbcl build-sbcl-internal output/base-image
	docker build -t sbcl-image -f Dockerfile-sbcl .
	touch output/sbcl-image

output/u-boot.bin output/mkimage: output/u-boot-image
	docker run -it --rm -v ./output:/output u-boot-image /build-u-boot-internal

output/Image: output/linux-image
	docker run -it --rm -v ./output:/output linux-image /build-linux-internal

output/busybox output/busybox-links: output/busybox-image
	docker run -it --rm -v ./output:/output busybox-image /build-busybox-internal

output/initramfs.cpio.gz: output/initramfs-image output/busybox
	docker run -it --rm -v ./output:/output initramfs-image /build-initramfs-internal

output/boot.scr: boot.cmd output/mkimage output/Image output/initramfs.cpio.gz
	docker run -it --rm -v ./boot.cmd:/boot.cmd -v ./output:/output base-image /output/mkimage -A riscv -T script -C none -n "Boot Script" -d /boot.cmd output/boot.scr

output/e2fsprogs.tar.gz: output/e2fsprogs-image
	docker run -it --rm -v ./output:/output e2fsprogs-image /build-e2fsprogs-internal

output/alpine.tar.gz:
	docker run --platform linux/riscv64 -it --rm -v ./output:/output alpine /bin/sh -c 'apk update && apk add parted && rm -rf /var/lib/apt/lists/* && tar zcvpf /output/alpine.tar.gz bin etc lib sbin tmp usr var'

output/glibc.tar.gz: output/glibc-image
	docker run -it --rm -v ./output:/output glibc-image /build-glibc-internal

output/sbcl.tar.gz: output/sbcl-image
	docker run -it --rm -v ./output:/output sbcl-image /build-sbcl-internal
