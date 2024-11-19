# Raspberry Pi OS from Scratch

*Experimentation with building operating systems for the Raspberry Pi from
scratch.*

## What's included

This repo contains experimentation and tinkering based on a guide written by
Jake Sandler ([jsandler18](https://github.com/jsandler18)) called
[Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/).

Versions of a minimal implementation of an OS for several versions of the
Raspberry Pi are included with associated build configuration and tooling.
Earlier versions of the Pi can be emulated with QEMU but other versions require
hardware to run.

### Raspberry Pi

The OG Raspberry Pi. Increasingly rare but I still have the one I preordered
many years ago.

### Raspberry Pi 2B

The 2B is supported by QEMU, which is used to run the OS on this version since
I don't have one.

### Raspberry Pi 3B

TODO

### Raspberry Pi 4B

TODO

## Usage

This project currently uses a simple Makefile for building the OS images.

TODO

## Acknowledgements

Always give credit where it's due.

- The `ubuntu-22.04-embedded` Docker image and associated VS Code Dev Container
  configuration were respectfully swiped from the very promising
  [adaptabuild](https://github.com/rhempel/adaptabuild) project by Ralph Hempel
  (@rhempel) for my own educational purposes of learning how to use dev
  containers and how adaptabuild works. If you're looking for a
  containerized embedded build system for VS Code, check it out!
