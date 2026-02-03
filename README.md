# linux-build-docker
## Purpose
Build the Linux kernel for RISCV on non-Linux systems like MacOS

## Usage

1. Build the base image

   ```
   ./build-base-image
   ```

   This will create `linux-builder-base:1.0.0`, which contains the
   necessary build tools to cross-compile Linux for riscv64. It
   also stores a clone of the Linux git repo and other repos needed.

2. Build the builder image
   ```
   ./build-builder-image
   ```
   This pulls the latest updates from upstream so the base image
   doesn't need to be rebuilt often. It also adds build scripts.

3. Run the actual builds

   ```
   ./build-u-boot
   ./build-linux
   ./build-initramfs
   ```

4. Find the resulting binaries in the `output` directory.

5. Run linux on qemu:

   ```
   ./run-uboot-linux [--share /shared/dir]
   ```

   where /shared/dir will be mounted at /mnt/host.
