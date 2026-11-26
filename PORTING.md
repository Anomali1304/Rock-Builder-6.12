# Rock Linux 6.12 Port Roadmap

Target: Poco M5 (rock), MediaTek MT6789 / Helio G99.

## Source roles

- Base: `Asmodeus7999/android_kernel_xiaomi_rock` (device kernel source; baseline currently 5.10).
- Linux 6.12 comparison: `riza220201/itel-rs4-kernel`, branch `6.12`. Reference only, not a device source.
- MTK vendor-module reference: `mt6789-transsion/android_kernel_devices_modules-6.12`. Use only files whose SoC/platform dependencies match MT6789 and after checking licensing and build integration.
- X6837 device tree: reference only. Never import its board configuration as Poco M5 configuration.

## Port phases

1. [x] Create the feature branch and pinned Kleaf reference CI scaffold; its IKKO target is not a Poco build.
2. [ ] Audit baseline: version, branch/commit, device DTS/DTB, defconfig, kernel config, in-tree MTK drivers, external modules and build scripts.
3. [ ] Establish a clean Linux 6.12 kernel tree and identify source/API migration deltas. Preserve upstream history where possible.
4. [ ] Port MT6789 SoC support and board-specific drivers. Resolve compile errors by subsystem, not by broad blind edits.
5. [ ] Port device DTS/DTSI, bindings, clocks, regulators, pinctrl, storage, display, touch, audio, camera, connectivity and thermal/power configuration based on the Poco M5 source and firmware.
6. [ ] Integrate matching vendor modules. Verify module dependencies, symbols, vermagic, signing policy and KMI/ABI expectations. A 6.12 kernel does not automatically support modules built for 5.10.
7. [ ] Build with target defconfig and validate DTBs, module list, image format and boot image packaging.
8. [ ] Static checks, artifact inspection and boot/recovery testing. No flashable release before validation.

## Safety/quality gates

- Never label a 5.10 build as 6.12.
- Do not replace Poco M5 DTS or defconfig with Itel/Infinix equivalents.
- Do not blindly copy vendor modules across kernel versions.
- The optional `//common/mindone:*` Actions target is an IKKO MindOne reference build, never a Poco M5 artifact.
- Keep port commits small and reviewable. Record source commit IDs in audit artifacts.
- Treat successful compilation as a milestone, not proof of bootability or hardware functionality.
