# Rock Builder 6.12

Builder and porting workspace for Poco M5 (rock), MT6789 / Helio G99.

## Current status

- [x] Builder repository initialized on branch `6.12`
- [x] Manual build workflow scaffold
- [x] Linux version guard (rejects source versions other than 6.12)
- [x] Source reconnaissance workflow and report script
- [x] Pinned Kleaf reference workflow scaffold (branch-scoped source sync; not a Poco build)
- [ ] Complete kernel port to 6.12
- [ ] Device DTS/DTB and defconfig migration
- [ ] Vendor-module migration and ABI checks
- [ ] AnyKernel packaging
- [ ] Boot/recovery validation

**Not a flashable kernel yet.** The intended Poco M5 baseline is the Asmodeus source, currently Linux 5.10. The build workflow rejects that baseline until a genuine 6.12 port exists.

## Source references

- Device baseline: https://github.com/Asmodeus7999/android_kernel_xiaomi_rock
- Linux 6.12 reference: https://github.com/riza220201/itel-rs4-kernel/tree/6.12
- MTK 6.12 modules reference: https://github.com/mt6789-transsion/android_kernel_devices_modules-6.12
- X6837 DTS: reference material only, not a Poco M5 device configuration.

## Workflows

- **Rock Linux 6.12 Builder**: build only a genuine 6.12 source.
- **Rock 6.12 Source Audit**: clones the references and uploads a source inventory artifact. Run it on branch `6.12`.
- **Poco M5 6.12 Kleaf CI (reference only)**: a push to `poco-m5-kleaf-port` that changes `ci/poco-m5-ikko.xml` runs pinned ACK/IKKO source sync; manual dispatch can optionally build IKKO MindOne reference targets. It is not a Poco build and does not publish images.

The source audit is not a port and does not modify kernel sources. The optional MindOne target is also reference-only and must not be flashed to a Poco M5. Porting is tracked in `PORTING.md`.
