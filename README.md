# linux-build-docker
## Purpose
Build the Linux kernel for RISCV on non-Linux systems like MacOS

## Usage
1. Build the base image
   ```./build-base-image```
   This will create linux-builder-base:1.0.0, which contains the
   necessary build tools to cross-compile Linux for riscv64. It
   also stores a clone of the Linux git repo.
2. Build the builder image
   ```./build-builder-image```
   This pulls the latest updates from upstream so the base image
   doesn't need to be rebuilt often. It also adds a build script.
3. Run the actual build
   ```./build-linux```
4. Find the resulting kernel in the `output` directory
