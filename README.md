# Rock Builder 6.12

Builder and porting workspace for Poco M5 (`stone`/`rock`), MediaTek MT6789 / Helio G99.

## Current status

- [x] Builder repository and feature branch `poco-m5-kleaf-port`
- [x] Pinned ACK/IKKO source-sync workflow on GitHub Actions
- [x] Actions runner source-sync validation completed successfully
- [ ] Poco-specific Linux 6.12 kernel port and Kleaf target
- [ ] Device DTS/DTBO and defconfig migration
- [ ] Vendor-module integration and ABI/symbol checks
- [ ] Poco image packaging and boot/recovery validation

**This is not a flashable kernel yet.** The device baseline is Linux 5.10; the existing IKKO MindOne target is only a method/build reference, not a Poco M5 source tree or device configuration.

## CI execution model

GitHub Actions is the primary reproducible source-sync/build environment. This repository stores the pinned manifests, port configuration, patches and scripts; Actions fetches upstream source into a temporary runner for each run. The large upstream source trees are not committed here. The local workspace can be used for source inspection and patch authoring, while actual CI builds will run in Actions.

## Source references

- Device baseline: https://github.com/Asmodeus7999/android_kernel_xiaomi_rock
- Linux 6.12 reference: https://github.com/riza220201/itel-rs4-kernel/tree/6.12
- MTK 6.12 modules reference: https://github.com/mt6789-transsion/android_kernel_devices_modules-6.12
- IKKO MindOne Kleaf reference: https://github.com/iasnezhkov/android_kernel_ikko_mindone/tree/android16-6.12
- X6837 DTS: reference material only, not a Poco M5 device configuration.

## Workflows

- **Poco M5 6.12 Kleaf CI (reference only)**: feature-branch changes to workflow, port configuration, patches, build scripts or roadmap trigger pinned source sync. Manual dispatch can optionally build IKKO MindOne reference targets. The current workflow does not build Poco images.
- **Rock 6.12 Source Audit**: source reconnaissance workflow and report tooling.

No result from a reference build establishes Poco compatibility or bootability. Porting milestones and safety gates are tracked in [`PORTING.md`](PORTING.md).
