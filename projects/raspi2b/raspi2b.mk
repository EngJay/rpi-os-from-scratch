##
# Raspberry Pi 2B Project Build Config
# 

# Get the directory of this Makefile.
# 
THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))
THIS_DIR := $(dir $(THIS_MAKEFILE))

# Set CPU and add project-specific flags.
# 
CPU := cortex-a7
CFLAGS += -DMODEL_2B

# Sources.
# 
SRCS += $(THIS_DIR)src/common/delay.c
SRCS += $(THIS_DIR)src/common/stdio.c
SRCS += $(THIS_DIR)src/common/stdlib.c

SRCS += $(THIS_DIR)src/kernel/kernel.c
SRCS += $(THIS_DIR)src/kernel/uart.c

SRCS += $(THIS_DIR)src/kernel/boot.S

# Include dirs.
# 
INC_DIRS += $(THIS_DIR)src/common
INC_DIRS += $(THIS_DIR)src/kernel

# Linker script.
# 
LD_SCRIPT := $(THIS_DIR)linker.ld
