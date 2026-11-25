#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
KERNEL_DIR="$ROOT/kernel"
OUT="$ROOT/out"
DEFCONFIG="${DEFCONFIG:-rock_defconfig}"
LTO_MODE="${LTO_MODE:-thin}"
BUILD_JOBS="${BUILD_JOBS:-4}"
CLANG_DIR="${CLANG_DIR:-}"

[[ -d "$KERNEL_DIR" ]] || { echo "Kernel source missing: $KERNEL_DIR"; exit 1; }
[[ -f "$KERNEL_DIR/Makefile" ]] || { echo "Missing kernel Makefile"; exit 1; }

VERSION=$(sed -n 's/^VERSION = //p' "$KERNEL_DIR/Makefile")
PATCHLEVEL=$(sed -n 's/^PATCHLEVEL = //p' "$KERNEL_DIR/Makefile")
[[ "$VERSION.$PATCHLEVEL" == "6.12" ]] || {
  echo "ERROR: source must be Linux 6.12, found $VERSION.$PATCHLEVEL"
  exit 1
}

mkdir -p "$OUT"
cd "$KERNEL_DIR"

if [[ -n "$CLANG_DIR" ]]; then
  export PATH="$CLANG_DIR:$PATH"
fi
command -v clang >/dev/null || { echo "clang not found in PATH"; exit 1; }

export ARCH=arm64
export LLVM=1
export LLVM_IAS=1

case "$LTO_MODE" in
  none) ;;
  thin) export LTO=thin ;;
  full) export LTO=full ;;
  *) echo "Unsupported LTO mode: $LTO_MODE"; exit 2 ;;
esac

make O="$OUT" "$DEFCONFIG"
make O="$OUT" -j"$BUILD_JOBS" Image.gz dtbs modules

cp "$OUT/arch/arm64/boot/Image.gz" "$OUT/" 2>/dev/null || cp "$OUT/arch/arm64/boot/Image" "$OUT/"
cp -r "$OUT/arch/arm64/boot/dts" "$OUT/dts" 2>/dev/null || true
find "$OUT" -name '*.ko' -exec cp --parents {} "$OUT/modules" \; 2>/dev/null || true

echo "Build completed. Output: $OUT"
