# GitHub Actions Kleaf Workflow

GitHub Actions is the primary reproducible source-sync and build environment for the Poco M5 6.12 port. The repository tracks manifests, port configuration, patches and scripts; each Actions run fetches the pinned upstream source into its temporary runner. The full upstream source tree is not checked into this repository. A local checkout may be used for source inspection and patch authoring, but the reproducible sync/build path is Actions.

## Triggers and modes

A push to `poco-m5-kleaf-port` that changes the workflow, `ci/**`, `patches/**`, `tools/**`, `kernel/**`, root build configuration, `README.md` or `PORTING.md` starts the pinned source-sync check. Manual dispatch currently offers:

- `source-sync`: sync the pinned source projects and verify their revisions.
- `ikko-reference-build`: manually build the IKKO MindOne reference targets `//common/mindone:mindone`, `//common/mindone:mindone_images` and `//common/mindone:mindone_dtbo`.

The reference build is not a Poco M5 build. Manual dispatch may require the workflow to be available on the repository's default branch; the feature-branch push trigger works independently.

## Pinned sources

- ACK manifest branch: `common-android16-6.12`
- ACK manifest commit: `1e6983be370c1baf010f37ca80f93abb419ebc39`
- IKKO kernel commit: `a71515dbaf0d539ffb36416f14186dad17eef743` from `android16-6.12`
- Local manifest override: `ci/poco-m5-ikko.xml`

The workflow verifies both commit IDs and fails closed if the ACK manifest branch no longer points at the reviewed pin.

## Current status and safety

The source-sync run [45757083279](https://github.com/Anomali1304/Rock-Builder-6.12/actions/runs/45757083279) completed successfully in about 7½ minutes and reported about 58 GB free on the runner after sync. This is one observed run, not a speed or capacity guarantee.

No Poco-specific Kleaf target exists yet, so the current workflow does not build or publish a Poco kernel, DTBO, vendor_boot or vendor_dlkm image. The optional MindOne build is reference-only and must not be flashed to a Poco M5. Before enabling a Poco candidate build, the port still needs device-matched DTS/DTBO and configuration, module integration/load lists, ABI/symbol checks, correct image packaging and validation gates. A successful compile would not by itself prove bootability.

The workflow has read-only repository permissions. It does not push code, deploy, or interact with a phone. Candidate artifacts will only be added after the Poco-specific target and safety checks are implemented.
