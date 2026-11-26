# Poco M5 Linux 6.12 DTS port — first stage

This branch carries the original Poco M5 (`rock`, MT6789) device-tree overlay and its two board-specific DTSI dependencies from `Asmodeus7999/android_kernel_xiaomi_rock` (`main`, baseline audit commit `ce449406786f1917d52192b13e0a9b09fc7b056b`). The overlay is being checked against the MTK 6.12 device-module tree `mt6789-transsion/android_kernel_devices_modules-6.12`, branch `lineage-23.2-kernel-6.12`.

The Actions workflow compiles the overlay as a DTBO only. Passing that syntax check does not establish semantic compatibility with the 6.12 base DT, successful kernel compilation, correct hardware behavior, or flashability. In particular, the target's reference tree is X6837-derived; board-specific phandles and drivers still require review and device validation.


## Provenance and validation update

The `bq2589x`, `flashlights_led191`, and `swtp` node definitions are copied from the MT6789 platform DTS in the Poco baseline commit, not inferred hardware. The baseline's `rock.dts` adds the Poco charger tuning and SWTP GPIO, while its `cust_l19a_camera.dtsi` applies Poco flashlight pinctrl settings. References: [baseline MT6789 DTS](https://github.com/Asmodeus7999/android_kernel_xiaomi_rock/blob/ce449406786f1917d52192b13e0a9b09fc7b056b/arch/arm64/boot/dts/mediatek/mt6789.dts), [baseline Poco rock.dts](https://github.com/Asmodeus7999/android_kernel_xiaomi_rock/blob/ce449406786f1917d52192b13e0a9b09fc7b056b/arch/arm64/boot/dts/mediatek/rock.dts), and [baseline camera DTSI](https://github.com/Asmodeus7999/android_kernel_xiaomi_rock/blob/ce449406786f1917d52192b13e0a9b09fc7b056b/arch/arm64/boot/dts/mediatek/cust_l19a_camera.dtsi).

The flashlight pinctrl properties are merged into the overlay's source-derived flashlight node because libfdt cannot use an overlay fragment to target another node created only inside that same overlay. The GitHub Actions run [45793569777](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/45793569777) successfully compiled the DTBO and applied it to the selected X6837-derived 6.12 reference base. This is not a full kernel build or boot/flash validation.

The 6.12 device-module source is [mt6789-transsion/android_kernel_devices_modules-6.12](https://github.com/mt6789-transsion/android_kernel_devices_modules-6.12/tree/lineage-23.2-kernel-6.12). Its build configuration expects a sibling `kernel-6.12` source tree and project `mgk_64_k612`; the exact common-kernel source/revision for a GitHub Actions build remains to be pinned and checked.
