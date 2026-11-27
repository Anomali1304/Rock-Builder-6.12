# Poco M5 Linux 6.12 port — kernel Image diagnostic

This branch carries the Poco M5 (`rock`, MT6789) device-tree overlay and board-specific DTSI dependencies derived from `Asmodeus7999/android_kernel_xiaomi_rock` at baseline commit `ce449406786f1917d52192b13e0a9b09fc7b056b`. The Actions build uses the publicly available mirror `jvaswb/android_kernel_devices_modules-6.12` at the exact device-module commit `293237daf841ec7288765775832ac9a3f51a6872`; the workflow now fetches that public mirror by exact commit SHA; the previously referenced `mt6789-transsion` URL failed during CI.

GitHub Actions compiles and applies the overlay as a DTBO, and now also has a diagnostic kernel-Image target. Passing either check does not establish full module compatibility, correct hardware behavior, flashability, or successful boot. In particular, the target reference tree is X6837-derived; board-specific phandles and drivers still require review and device validation.


## Provenance and validation update

The `bq2589x`, `flashlights_led191`, and `swtp` node definitions are copied from the MT6789 platform DTS in the Poco baseline commit, not inferred hardware. The baseline's `rock.dts` adds the Poco charger tuning and SWTP GPIO, while its `cust_l19a_camera.dtsi` applies Poco flashlight pinctrl settings. References: [baseline MT6789 DTS](https://github.com/Asmodeus7999/android_kernel_xiaomi_rock/blob/ce449406786f1917d52192b13e0a9b09fc7b056b/arch/arm64/boot/dts/mediatek/mt6789.dts), [baseline Poco rock.dts](https://github.com/Asmodeus7999/android_kernel_xiaomi_rock/blob/ce449406786f1917d52192b13e0a9b09fc7b056b/arch/arm64/boot/dts/mediatek/rock.dts), and [baseline camera DTSI](https://github.com/Asmodeus7999/android_kernel_xiaomi_rock/blob/ce449406786f1917d52192b13e0a9b09fc7b056b/arch/arm64/boot/dts/mediatek/cust_l19a_camera.dtsi).

The flashlight pinctrl properties are merged into the overlay's source-derived flashlight node because libfdt cannot use an overlay fragment to target another node created only inside that same overlay. The GitHub Actions run [46034697273](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/46034697273) successfully fetched the pinned reference source, compiled the DTBO, and applied it to the selected X6837-derived 6.12 reference base. This remains a smoke check, not a full kernel build or boot/flash validation.

The 6.12 device-module source used by CI is the mirror commit [jvaswb/android_kernel_devices_modules-6.12@293237d](https://github.com/jvaswb/android_kernel_devices_modules-6.12/commit/293237daf841ec7288765775832ac9a3f51a6872). Its build configuration expects a sibling `kernel-6.12` source tree and project `mgk_64_k612`.

## Kernel source and build path

The selected upstream manifest is [common-android16-6.12](https://android.googlesource.com/kernel/manifest/+/refs/heads/common-android16-6.12/default.xml). Its manifest pins `kernel/common` to branch `android16-6.12` and `kernel/build` to `main-kernel-2025`; it also links the Kleaf launcher as `tools/bazel`. The MTK device-module branch advertises `mgk_64_k612` as Kleaf-supported and expects a sibling source tree named `kernel-6.12`, so the Actions manifest maps the common kernel project to that path.

The upstream MTK project config also lists numerous `//vendor/mediatek/kernel_modules/...` targets, while the public device-modules repository does not include a `vendor/mediatek` tree. The full target therefore remains dependent on whether those external source packages are available in the build environment; a successful DTBO smoke check is not evidence that this full target or the Poco device will boot.


## Current GitHub Actions result — 2026-11-28

- **Kernel Image compile: passed (diagnostic scope).** Run [45980303710](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/45980303710), commit `de903faf7308dba02a54bb9f71fac731e71e957b`, built target `//kernel_device_modules-6.12:mgk_64_k612_kernel_aarch64.user` successfully (609 Bazel actions). The log lists `vmlinux`, `Image`, `Image.lz4`, and `Image.gz`.
- **Artifact:** [poco-m5-6.12-kernel-image-user-diagnostic](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/45980303710/artifacts/15191370720) (about 424 MB; Actions retention applies).
- **Important KMI limitation:** this diagnostic run uses `--nokmi_symbol_list_violations_check` after a prior run found missing KMI symbols. Therefore, the success proves the selected kernel target compiled; it does **not** prove that unsigned vendor modules can use the kernel's exported symbols.
- **Full vendor modules: not built.** The latest full-module probe, run [46042285104](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/46042285104) at commit `1e50060eb32fff5247d0495bac5ee45829291ca7`, passed source fetch and got past Mali, Bluetooth, and the HBT package check, then stopped during Kleaf analysis because `vendor/mediatek/kernel_modules/fpsgo_cus` is absent. HBT was excluded only in the CI runner because it is not listed in Poco's published stock `modules.load` files; this is not a successful module build.
- **FPSGO source gap remains material.** Poco's stock `modulesdlkm/modules.load` lists both `mtk_fpsgo.ko` and `fpsgo.ko`. The available 6.12 device-module tree defines a separately named `mtk_fpsgo_v8` target, but its Makefile has the output object lines commented out; it does not prove those Poco modules can be built. A checked Samsung MT6789 source tree exposes only `connectivity`, `gpu`, and `met_drv_v3` under `vendor/mediatek/kernel_modules`, and is a Linux 5.10 tree. No verified Poco-compatible 6.12 source for `fpsgo_cus` or the camera package was found. Do not drop these required modules or substitute different-SoC sources merely to get a green CI run.
- **DTBO smoke test: passed.** Run [46034697273](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/46034697273), commit `ddf2da65466a820405b9282773ac29a137fbcb3b`, fetched the pinned source and compiled/applied the Poco overlay to the selected MT6789 reference DTB. The reference tree is X6837-derived and is not a Poco M5 device test.

This is not a full kernel-plus-vendor-modules package and has not been flashed or boot-tested on a Poco M5. Treat the Image artifact as a CI compile result only, not a device-ready boot image.
