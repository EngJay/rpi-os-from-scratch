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
PI_MODEL ?=
SUPPORTED_PI_MODELS := 1 2b 3b 4b

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

# Build output.
# 
IMG_NAME := kernel.img
TARGET = $(BUILD_DIR)/raspi$(PI_MODEL)/$(IMG_NAME)

# Toolchain.
# 
TOOLCHAIN_PREFIX := arm-none-eabi
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

# Include model-specific concrete sources and build config.
# 
include projects/raspi$(PI_MODEL)/raspi$(PI_MODEL).mk

# Compiler/linker arguments. 
# 
CFLAGS += -mcpu=$(CPU) -fpic -ffreestanding -nostdlib -Wall -Wextra
LFLAGS += -mcpu=$(CPU) -ffreestanding -nostdlib

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

# Phone targets.
# 
.PHONY: build clean run

# Default target.
# 
build: $(TARGET)

$(BUILD_DIR)/raspi$(PI_MODEL)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/raspi$(PI_MODEL)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	$(CC) -T$(LD_SCRIPT) $(OBJS) -o $@ $(LFLAGS)

clean:
	$(Q)$(RMDIR) build

run: build
	@if [ "$(PI_MODEL)" = "1" ]; then \
		qemu-system-arm -m 512 -M raspi1ap -serial stdio -kernel $(TARGET); \
	elif [ "$(PI_MODEL)" = "2b" ]; then \
		qemu-system-arm -m 1024 -M raspi2b -serial stdio -kernel $(TARGET); \
	else \
		echo "Unsupported PI_MODEL for run target."; \
	fi
