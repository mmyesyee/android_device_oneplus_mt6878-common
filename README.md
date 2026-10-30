# MT6878 platform tree (OnePlus, MediaTek Dimensity 7300)

Shared configuration for LineageOS 24.0 devices built on the MediaTek MT6878
platform. The per-device tree (`device/oneplus/OP68F7L1`) inherits
`BoardConfigCommon.mk` and `common.mk` from here and only adds what is specific
to the model (partition sizes are identical across the platform, so they live
here; the assert, screen density, fingerprint position and fastboot info stay in
the device tree).

## What is here

| Path | Contents |
| --- | --- |
| `BoardConfigCommon.mk` | architecture, A/B + virtual A/B, kernel offsets, boot header 4, super layout (group `main`), EROFS/F2FS, AVB, sepolicy dirs, Wi-Fi |
| `common.mk` | virtual A/B userspace, update_engine, init scripts + fstab, properties, shipping API level |
| `configs/vintf/` | stock `/vendor` manifest and compatibility matrix (excluded from `proprietary-files.txt`) |
| `configs/props/` | `vendor.prop`, `odm.prop`, `system.prop`, `product.prop` generated from the ColorOS 16 (Android 16) build |
| `init/` | stock `fstab.mt6878`, the 13 vendor `init.*.rc` files and `ueventd.mt6878.rc` |
| `sepolicy/` | vendor / system_ext private / public policy (106 files) |

## Kernel, vendor_boot and dtbo

None of them are built. The kernel is a prebuilt stock `Image` from
`device/oneplus/OP68F7L1-kernel`, while `vendor_boot` (DTB + vendor ramdisk +
kernel modules) and `dtbo` stay exactly as OPLUS shipped them.

## License

Apache-2.0, same as LineageOS.
