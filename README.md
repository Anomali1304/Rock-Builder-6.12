# Rock Builder 6.12

GitHub Actions builder scaffold for the Poco M5 (rock) Linux 6.12 kernel port.

## Status

- [x] Initialize repo and development branch `6.12`
- [x] Manual GitHub Actions workflow
- [x] Cloud dependencies and source checkout
- [x] Linux 6.12 source-version guard
- [x] Basic kernel build script
- [ ] Port source to Linux 6.12
- [ ] Device defconfig and DT integration
- [ ] Vendor modules integration and ABI checks
- [ ] AnyKernel packaging
- [ ] Boot and recovery validation

**The port is not complete.** Asmodeus Rock kernel is the intended 5.10 baseline. The builder refuses to build anything except Linux 6.12, preventing a 5.10 build from being mislabeled.

## Run

1. Open Actions.
2. Select **Rock Linux 6.12 Builder**.
3. Run the workflow on branch `6.12`.
4. Choose a source repo/ref that is actually Linux 6.12, defconfig, LTO, and job count.
5. Download the workflow artifact.

## Defaults

- Device: Poco M5 (rock)
- Architecture: arm64
- Compiler: LLVM/Clang
- LTO: Thin
- Intended source baseline: Asmodeus Rock kernel
- Target: Linux 6.12

This is an initial builder scaffold. Device porting and packaging work remain.
