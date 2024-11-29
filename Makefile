##
# Raspberry Pi OS from Scratch
# 
# Minimal operating system image and build configuration for the Raspberry Pi.
# The OS is comprised of a minimal kernel with one UART configured to print a
# "Hello, kernel world!" message and echo back keystrokes. 
# 
# The default target is the Raspberry Pi 2B, which can be run with QEMU. A run
# target builds the OS image and runs it with qemu-system-arm.
# 
# Invoke the build system with:
#
# 	make PI_MODEL=xxx target
#
# Raspberry Pi model (Options: 1, 2b, 3b, 4b)
# 

# Raspberry Pi model (Options: 1, 2b, 3b, 4b)
# 
# Model 2B is the default.
# 
# @author Jason Scott
# @date 2024-11-25
# @copyright Copyright (c) 2024
# 

# Raspberry Pi model to target.
# 
PI_MODEL ?=
SUPPORTED_PI_MODELS := 1 2b 3b 4b

# Build and debug settings.
# 
MKPATH := mkdir -p
VERBOSE ?= 0
Q = $(if $(VERBOSE),, @) 
RM := rm -rf
RMDIR := rm -rf

DEBUG ?= 0
ifeq (1,$(DEBUG))
BUILD_TYPE := debug
CFLAGS += -g -O2
else
BUILD_TYPE := release
CFLAGS += -O3
endif
BUILD_DIR ?= build/$(BUILD_TYPE)

# Toolchain.
# 
# Default to 32-bit mode, arm-none-eabi, but is overriden in included model
# Makefiles.
# 
TOOLCHAIN_PREFIX = arm-none-eabi
CC      = $(TOOLCHAIN_PREFIX)-gcc
LD      = $(TOOLCHAIN_PREFIX)-ld
AR      = $(TOOLCHAIN_PREFIX)-ar
OBJCOPY = $(TOOLCHAIN_PREFIX)-objcopy

# GLOBAL variables updated across Makefiles.
# 
CPU :=
CFLAGS :=
LFLAGS :=
LD_SCRIPT :=
INC_DIRS :=
OBJS :=
SRCS :=

# Extra libraries, if required.
# 
LIBS :=

# Targets whitelisted from the guardrails on PI_MODEL.
# 
# This allows targets like distclean to be run without setting PI_MODEL. 
# 
WHITELISTED_TARGETS := distclean 

# Whitelist certain targets that are not dependent on PI_MODEL from guardrails.
# 
# TODO Determine if this is reasonable - not a fan of the nested conditional. #1.
# 
ifeq ($(filter $(WHITELISTED_TARGETS),$(MAKECMDGOALS)),)
# Bail if model is not set.
# 
ifndef PI_MODEL
$(error PI_MODEL is not set. Please set it before running make.)
endif

# Bail if model is not supported.
# 
ifeq ($(filter $(PI_MODEL), $(SUPPORTED_PI_MODELS)),)
$(error $(PI_MODEL) is not supported. Supported targets: $(SUPPORTED_PI_MODELS))
endif

# Include model-specific concrete sources and build config.
# 
include projects/raspi$(PI_MODEL)/raspi$(PI_MODEL).mk
endif

# Initial output is .elf, then converted to .img.
# 
TARGET = $(BUILD_DIR)/raspi$(PI_MODEL)/$(IMG_NAME).elf

# Compiler/linker arguments. 
# 
# TODO better handle build args for 32 vs 64 bit and common args, #2.
# 
CFLAGS += -mcpu=$(CPU) -nostdlib -nostartfiles  -ffreestanding -mgeneral-regs-only -Wall -Wextra
LFLAGS += 

# Flags set with DEBUG setting.
#
# Defaults to release build.
# 
ifeq ($(DEBUG),1)
CFLAGS += -g -O2
else
CFLAGS += -O3
endif

# Abstract sources.
# 
# SRCS +=

# Objects.
# 
OBJS := $(patsubst %.c, $(BUILD_DIR)/raspi$(PI_MODEL)/%.o, $(filter %.c, $(SRCS))) \
        $(patsubst %.S, $(BUILD_DIR)/raspi$(PI_MODEL)/%.o, $(filter %.S, $(SRCS)))

# Abstract inc dirs.
# 
INC_DIRS += src/common
INC_DIRS += src/kernel

# Include flags.
# 
CFLAGS += $(addprefix -I,$(INC_DIRS))

# Wipe known suffixes and set phoney targets.
# 
.SUFFIXES:
.PHONY: build clean run

# Default target.
# 
build: $(TARGET)

run: build
	@if [ "$(PI_MODEL)" = "1" ]; then \
		qemu-system-arm -m 512 -M raspi1ap -serial stdio -kernel $(TARGET); \
	elif [ "$(PI_MODEL)" = "2b" ]; then \
		qemu-system-arm -m 1024 -M raspi2b -serial stdio -kernel $(TARGET); \
	else \
		echo "Unsupported PI_MODEL for run target."; \
	fi

$(TARGET): $(OBJS)
	$(LD) -T$(LD_SCRIPT) $(OBJS) -o $@ $(LFLAGS)
	$(OBJCOPY) $@ -O binary $(patsubst %.elf,%.img,$@)

$(BUILD_DIR)/raspi$(PI_MODEL)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -D__ASSEMBLY__ -c $< -o $@

$(BUILD_DIR)/raspi$(PI_MODEL)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

distclean:
	$(Q)$(RMDIR) build
