# OP68F7L1 stock prop fragments

Stock ColorOS 16 (PYS110_11_A.01_260716, Android 16 / SDK 36) build.prop
values, filtered. All values are verbatim stock.

| file | stock source | lines | kept |
| --- | --- | --- | --- |
| vendor.prop | /vendor/build.prop | 829 | 637 |
| odm.prop | /odm/build.prop | 118 | 101 |
| system.prop | /system/build.prop | 250 | 23 |
| product.prop | /product/etc/build.prop | 29 | 5 |

vendor.prop's 829 lines are two stacked stock blocks: 690 unique keys,
637 kept (duplicates collapse to the last stock value, as at runtime).
odm.prop also carries ro.oplus.components.list and product.prop
ro.oplus.audio.product.para; both from the runtime getprop dump (stock
keeps them on /my_product, which LOS does not ship).

Dropped: ro.build.*, ro.product.*, ro.system.*, ro.odm.*,
ro.vendor.build.*, ro.vendor.product.cpu.abilist*, ro.bionic.*,
ro.treble.*, ro.vndk.version, ro.vendor.api_level, ro.board.api_level,
ro.board.first_api_level, ro.boot.*, ro.zygote*, dalvik.vm.*,
ro.debuggable, ro.secure, ro.adb.*, security.perf_harden, net.bt.name,
ro.sf.lcd_density, empty props, odm "import" lines, MTK/AOSP build
defaults. Set TARGET_SCREEN_DENSITY := 480 in BoardConfig.mk instead.

Kept ro.build./ro.product. exceptions (stock /odm):
ro.build.device_family, ro.build.kernel.id, ro.product.oplus.cpuinfo.

Cross-partition duplicates (winner): ro.netflix.bsp_rev=odm;
ro.mediatek.version.release=odm; ro.vendor.mediatek.version.release=odm;
ro.lmk.swap_free_low_percentage=odm; ro.lmk.limit_killing_array_kb=odm;
bluetooth.profile.sap.server.enabled=vendor; ro.opengles.version,
ro.apex.updatable, ro.cp_system_other_odex, debug.sf.*,
ro.surface_flinger.*, debug.stagefright.c2inputsurface=vendor;
ro.zygote and the cpu.abilists dropped everywhere (build-generated).
drm.service.enabled=vendor (true): stock /odm's false is an OPlus
override that would disable the DRM service on LOS.
