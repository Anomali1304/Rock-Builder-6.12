# GitHub Actions Kleaf Reference Workflow

The workflow at `.github/workflows/poco-m5-kleaf-reference.yml` is a manual CI scaffold for validating the ACK/Kleaf method used by the IKKO MindOne reference. A push to `poco-m5-kleaf-port` that changes the workflow or a file under `ci/` starts the pinned source-sync check. It does not yet build a Poco M5 kernel.

## Pinned sources

- ACK manifest branch: `common-android16-6.12`
- ACK manifest commit: `1e6983be370c1baf010f37ca80f93abb419ebc39`
- IKKO kernel commit: `a71515dbaf0d539ffb36416f14186dad17eef743` from `android16-6.12`
- Local manifest override: `ci/poco-m5-ikko.xml`

The workflow verifies both commit IDs and fails closed if the ACK manifest branch no longer points at the reviewed pin.

## Modes and outputs

- `source-sync`: sync the pinned source projects and verify revisions. This is the mode used by a qualifying feature-branch push.
- `ikko-reference-build`: manually build `//common/mindone:mindone`, `//common/mindone:mindone_images`, and `//common/mindone:mindone_dtbo` to test the reference Kleaf path.

The optional build targets and any generated files belong to IKKO MindOne. The workflow intentionally does not upload or label any resulting image as a Poco artifact. It has read-only repository permissions and does not push code, deploy, or touch a device. GitHub only offers manual `workflow_dispatch` for a workflow present on the default branch; the feature-branch push path is independent of that limitation.

## Current limitations

This workflow has not yet been run, so GitHub runner speed, disk headroom, and Bazel build success are unverified. Actions still needs to fetch the same large ACK/prebuilt sources, and an ephemeral runner may have different disk limits than this sandbox.

Before this can build Poco M5, the port still needs a Poco-specific Kleaf target, board DTS/DTBO and configuration, device-matched module integration/load lists, ABI/symbol checks, and correct image packaging. A successful IKKO reference build would validate only the build environment and reference method, not Poco compatibility or bootability.
