##
# Raspberry Pi 3B Project Build Config
# 

# Get the directory of this Makefile.
# 
THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))
THIS_DIR := $(dir $(THIS_MAKEFILE))

# Build for 64-bit.
# 
TOOLCHAIN_PREFIX = aarch64-linux-gnu

# Set CPU and add project-specific flags.
# 
CPU := cortex-a53
CFLAGS += -DMODEL_3B
IMG_NAME := kernel8
IMG_SUFFIX := elf

# Sources.
# 
SRCS += $(THIS_DIR)src/common/mini_uart.c

SRCS += $(THIS_DIR)src/kernel/kernel.c

SRCS += $(THIS_DIR)src/kernel/boot.S
SRCS += $(THIS_DIR)src/kernel/mm.S
SRCS += $(THIS_DIR)src/kernel/utils.S

# Include dirs.
# 
INC_DIRS += $(THIS_DIR)src/common
INC_DIRS += $(THIS_DIR)src/kernel

# Linker script.
# 
LD_SCRIPT := $(THIS_DIR)linker.ld
