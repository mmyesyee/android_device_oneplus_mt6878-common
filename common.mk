#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# This tree reuses the complete stock /vendor and /odm partitions as blobs
# (see the device tree's proprietary-files.txt / extract-files.py). Only the
# Android framework side is built from source, therefore common.mk does not
# pull any vendor HAL from hardware/mediatek: the ones shipped in ColorOS stay
# in place.

# Inherit from the AOSP products we build on.
# Note: launch_with_vendor_ramdisk.mk is deliberately not inherited; it installs
# modules into the vendor ramdisk, and vendor_boot is not built by this tree.
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

# The stock vendor_boot is used as-is, so the first-stage ramdisk content and
# the kernel modules still come from ColorOS; the userspace side of virtual A/B
# (snapuserd, update_engine) is built here.
PRODUCT_VIRTUAL_AB_COMPRESSION := true
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# We build super ourselves: system/system_ext/vendor/product/odm land in the
# "main" group defined in BoardConfigCommon.mk.
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# OTA postinstall (dynamic partitions are EROFS, userdata is F2FS)
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    otapreopt_script \
    update_engine \
    update_engine_client \
    update_verifier

# Init scripts and fstab. These files live in the vendor partition and are
# excluded from proprietary-files.txt, so they are installed from here.
PRODUCT_PACKAGES += \
    fstab.mt6878 \
    init.aee.rc \
    init.cgroup.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init_conninfra.rc \
    init.modem.rc \
    init.mt6878.rc \
    init.mt6878.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.pstore.rc \
    init.sensor_2_0.rc \
    ueventd.mt6878.rc

# 34 (not 36, the stock ro.product.first_api_level): the vendor blobs report
# ro.vendor.api_level=34 / ro.vndk.version=34, and a lower shipping level means
# the Android 17 framework does not demand mainline APEXes / newer HALs that a
# ColorOS 16 vendor cannot provide.
PRODUCT_SHIPPING_API_LEVEL := 34

PRODUCT_SOONG_NAMESPACES += \
    device/oneplus/mt6878-common \
    hardware/mediatek
