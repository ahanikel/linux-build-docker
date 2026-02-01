fatload virtio 0:1 0x80200000 Image
fatload virtio 0:1 0x84000000 initramfs.cpio.gz
setenv bootargs "console=ttyS0 root=/dev/ram0 rdinit=/init"
booti 0x80200000 0x84000000:$filesize $fdtcontroladdr
