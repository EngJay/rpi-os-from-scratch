# Raspberry Pi OS from Scratch

*Experimentation with building operating systems for the Raspberry Pi from
scratch.*

## What's included

This repo began as experimentation and tinkering based on a guide written by
Jake Sandler ([jsandler18](https://github.com/jsandler18) on GitHub) called
[Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/)
but has grown to include more versions of the Pi and pulling in materials from
many sources.

Versions of a minimal implementation of an OS for several versions of the
Raspberry Pi are included with associated build configuration and tooling.

### Raspberry Pi 2B

The kernel has been tested only on QEMU since I don't have one.

### Raspberry Pi 3B and 4B

The kernel has been tested on the hardware. The kernel runs in QEMU but the UART
output is not received for unknown reasons, so the 3B/4B are not included in the
run target. 

## Usage

This project currently uses a simple Makefile for building the OS images.

To build the kernel, in the repo root run make with the PI_MODEL set to 2b or 3b.

```bash
make PI_MODEL=[2b,3b,4b]
```

A distclean targest is included to remove the build artifacts.

```bash
make distclean
```

## Acknowledgements

Always give credit where it's due.

- The `ubuntu-22.04-embedded` and `ubuntu-24.04-embedded` Docker images and
  associated VS Code Dev Container  configuration were respectfully swiped from
  the very promising [adaptabuild](https://github.com/rhempel/adaptabuild)
  project by Ralph Hempel ([rhempel](https://github.com/rhempel) on GitHub) for
  my own educational purposes of learning how to use dev containers and how
  adaptabuild works and modified. If you're looking for a containerized embedded
  build system for VS Code, check it out!

- The initial inspiration for this repo was the guide written by Jake Sandler
  ([jsandler18](https://github.com/jsandler18) on GitHub) called
  [Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/).

- Sergey Matyukevich's ([s-matyukevich](https://github.com/s-matyukevich)) guide
  on GitHub,
  [Learning operating system development using Linux kernel and Raspberry Pi](https://github.com/s-matyukevich/raspberry-pi-os),
  served as the starting point for the 3B.
