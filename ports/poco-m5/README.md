# Poco M5 Linux 6.12 DTS port — first stage

This branch carries the original Poco M5 (`rock`, MT6789) device-tree overlay and its two board-specific DTSI dependencies from `Asmodeus7999/android_kernel_xiaomi_rock` (`main`, baseline audit commit `ce449406786f1917d52192b13e0a9b09fc7b056b`). The overlay is being checked against the MTK 6.12 device-module tree `mt6789-transsion/android_kernel_devices_modules-6.12`, branch `lineage-23.2-kernel-6.12`.

The Actions workflow compiles the overlay as a DTBO only. Passing that syntax check does not establish semantic compatibility with the 6.12 base DT, successful kernel compilation, correct hardware behavior, or flashability. In particular, the target's reference tree is X6837-derived; board-specific phandles and drivers still require review and device validation.
