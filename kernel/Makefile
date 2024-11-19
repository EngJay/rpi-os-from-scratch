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

# Raspberry Pi model (Options: 1, 2b, 3b, 4b)
# 
PI_MODEL ?= 2b

# Filename of OS image.
# 
IMG_NAME = kernel.img

# Build and debug settings.
# 
BUILD_DIR ?= build
DEBUG ?= 0
MKPATH := mkdir -p
VERBOSE ?= 0
Q = $(if $(VERBOSE),, @) 
RM := rm -rf
RMDIR := rm -rf

# Toolchain.
# 
TOOLCHAIN_PREFIX := arm-none-eabi
CC      = $(TOOLCHAIN_PREFIX)-gcc
LD      = $(TOOLCHAIN_PREFIX)-ld
AR      = $(TOOLCHAIN_PREFIX)-ar
OBJCOPY = $(TOOLCHAIN_PREFIX)-objcopy

# Model-specific additions.
# 
ifeq (1,$(PI_MODEL))
	CPU := arm1176jzf-s
	CFLAGS = -DMODEL_1
else ifeq (2b,$(PI_MODEL))
	CPU := cortex-a7
	CFLAGS = -DMODEL_2
else ifeq (3b,$(PI_MODEL))
	CPU := cortex-a53
	CFLAGS = -DMODEL_3
else ifeq (4b,$(PI_MODEL))
	CPU := cortex-a72
	CFLAGS = -DMODEL_4
else
	$(error Unsupported or unset PI_MODEL. Valid options: 1, 2b, 3b, 4b)
endif

# Compiler/linker arguments. 
# 
CFLAGS += -mcpu=$(CPU) -fpic -ffreestanding -nostdlib -Wall -Wextra
LFLAGS := -ffreestanding -nostdlib

# Flags set with DEBUG setting.
#
# Defaults to release build.
# 
ifeq ($(DEBUG),1)
CFLAGS += -g -O2
else
CFLAGS += -O3
endif

# Directories.
# 
KER_INC_DIR = $(PI_MODEL)/inc/kernel
KER_SRC_DIR = $(PI_MODEL)/src/kernel
COMMON_INC_DIR = $(PI_MODEL)/inc/common
COMMON_SRC_DIR = $(PI_MODEL)/src/common
OBJ_DIR = $(BUILD_DIR)/$(PI_MODEL)/objects

# Format include flags.
# 
KER_INC_FLAGS := $(addprefix -I,$(KER_INC_DIR))
COMMON_INC_FLAGS := $(addprefix -I,$(COMMON_INC_DIR))

# Sources.
# 
KER_SRCS = $(wildcard $(KER_SRC_DIR)/*.c)
COMMON_SRCS = $(wildcard $(COMMON_SRC_DIR)/*.c)
ASM_SRCS = $(wildcard $(KER_SRC_DIR)/*.S)

# Outputs.
# 
OBJECTS = $(patsubst $(KER_SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(KER_SRCS))
OBJECTS += $(patsubst $(COMMON_SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(COMMON_SRCS))
OBJECTS += $(patsubst $(KER_SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(ASM_SRCS))

# Include flags.
#
CFLAGS += $(addprefix -I, $(KER_INC_DIR) $(COMMON_INC_DIR))

# Linker script.
# 
LD_SCRIPT = $(PI_MODEL)/linker.ld

build: $(OBJECTS)
	@echo "Linking..."
	$(Q)$(MKPATH) $(BUILD_DIR)
	$(Q)$(CC) -T$(LD_SCRIPT) -o $(IMG_NAME) $(LFLAGS) $(OBJECTS)

$(OBJ_DIR)/%.o: $(KER_SRC_DIR)/%.c
	$(Q)$(MKPATH) $(@D)
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(COMMON_SRC_DIR)/%.c
	$(Q)$(MKPATH) $(@D)
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(KER_SRC_DIR)/%.S
	$(Q)$(MKPATH) $(@D)
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(Q)$(RM) $(BUILD_DIR) $(IMG_NAME)

run: build
	@if [ "$(PI_MODEL)" = "2b" ]; then \
		qemu-system-arm -m 1024 -M raspi2b -serial stdio -kernel $(IMG_NAME); \
	else \
		echo "Unsupported PI_MODEL for run target."; \
	fi
