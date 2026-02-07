fatload virtio 0:1 $kernel_addr_r Image
fatload virtio 0:1 $ramdisk_addr_r initramfs.cpio.gz
setenv bootargs "console=ttyS0 root=/dev/ram0 rdinit=/init"
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdtcontroladdr
