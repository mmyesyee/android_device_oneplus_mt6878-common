#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/oneplus/mt6878-common

# Allow the same variable to be defined by more than one makefile
BUILD_BROKEN_DUP_RULES := true

# A/B
# boot, init_boot, vendor_boot and dtbo are never rebuilt: the stock images
# carry the kernel, the vendor ramdisk, the DTB and the kernel modules. The
# OTA payload therefore only contains the partitions this tree actually builds.
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    odm \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor

# Architecture (MT6878: 4x Cortex-A78 + 4x Cortex-A55)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a78

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55

# The stock system ships a full set of 32-bit libraries even though every app
# is 64-bit only, so keep the secondary architecture but never start a 32-bit
# zygote.
IGNORE_PREFER32_ON_DEVICE := true
TARGET_DYNAMIC_64_32_DRMSERVER := true
TARGET_DYNAMIC_64_32_MEDIASERVER := true
ZYGOTE_FORCE_64 := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := mt6878
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := mt6878
BOARD_USES_MTK_HARDWARE := true

# HIDL / VINTF
# The stock /vendor manifest and compatibility matrix are kept in this tree so
# that they can be edited, and are excluded from proprietary-files.txt.
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE += $(COMMON_PATH)/configs/vintf/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/mediatek/vintf/mediatek_framework_compatibility_matrix.xml

# Recovery
# There is no recovery partition on this platform: recovery lives in the vendor
# boot ramdisk, which is left untouched (stock). Only the fstab is needed by
# the build system.
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/init/fstab.mt6878
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USES_METADATA_PARTITION := true

# Kernel
# The kernel is NOT built from source. The stock kernel (uncompressed Image,
# extracted from the stock boot image) is shipped in a separate repository; the
# device tree sets TARGET_PREBUILT_KERNEL to point at it.
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_OFFSET := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_TAGS_OFFSET := 0x07c80000
BOARD_RAMDISK_OFFSET := 0x26f00000
BOARD_BOOT_HEADER_VERSION := 4
BOARD_INIT_BOOT_HEADER_VERSION := 4

BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_KERNEL_IMAGE_NAME := Image

# Same command line that the stock vendor_boot carries (unpack_bootimg reports
# "bootopt=64S3,32N2,64N2 androidboot.selinux=permissive").
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

TARGET_FORCE_PREBUILT_KERNEL := true
# Without this, soong still runs generated_kernel_includes against
# kernel/oneplus/<device>, which does not exist (the kernel is prebuilt).
TARGET_NO_KERNEL_OVERRIDE := true

# Partitions
BOARD_PRODUCTIMAGE_MINIMAL_PARTITION_RESERVED_SIZE := false
-include vendor/lineage/config/BoardConfigReservedSize.mk

# BOARD_KERNEL_PAGESIZE * 64
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_EROFS_PCLUSTER_SIZE := 65536

BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_SUPER_PARTITION_SIZE := 16911433728

# The stock device uses a virtual A/B super partition with a single group
# ("main"). Only the partitions that this tree builds are listed: vendor_dlkm,
# odm_dlkm, system_dlkm and the ten "my_*" partitions are kept from ColorOS and
# must not be recreated, otherwise their content (OPLUS vendor blobs, overlays
# merged in by the stock fstab) disappears.
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    vendor \
    product \
    odm
BOARD_MAIN_DYNAMIC_PARTITIONS_SIZE := 16907239424

# The stock fstab expects EROFS first for every dynamic partition (ext4 is
# listed as the fallback).
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# Properties
TARGET_PRODUCT_PROP += $(COMMON_PATH)/configs/props/product.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/configs/props/vendor.prop
TARGET_SYSTEM_PROP += $(COMMON_PATH)/configs/props/system.prop
TARGET_ODM_PROP += $(COMMON_PATH)/configs/props/odm.prop

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
BOOT_SECURITY_PATCH := 2026-07-01
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Sepolicy
include device/mediatek/sepolicy_vndr/SEPolicy.mk
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/basic/non_plat
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/public

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_ROLLBACK_INDEX := 1

BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := $(BOARD_AVB_ALGORITHM)
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(BOARD_AVB_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 1
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# Wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_DRIVER_FW_PATH_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_FW_PATH_STA := "STA"
WIFI_DRIVER_FW_PATH_AP := "AP"
WIFI_DRIVER_FW_PATH_P2P := "P2P"
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_STATE_ON := "1"
WIFI_DRIVER_STATE_OFF := "0"
WIFI_HAL_INTERFACE_COMBINATIONS := {{{STA}, 2}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{AP}, 2},}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{AP}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{P2P}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{NAN}, 1}}
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
