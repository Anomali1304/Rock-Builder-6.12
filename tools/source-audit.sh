#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-sources}"
OUT="${2:-audit}"
mkdir -p "$OUT"
{
  echo "# Source reconnaissance"
  echo "Generated: $(date -u +%FT%TZ)"
  for name in rock-base rs4-612 mtk-modules-612; do
    dir="$ROOT/$name"
    echo
    echo "## $name"
    if [[ ! -d "$dir" ]]; then echo "Missing source directory"; continue; fi
    git -C "$dir" remote -v | head -n 2 || true
    git -C "$dir" log -1 --format='Commit: %H%nCommit date: %cI%nSubject: %s' || true
    if [[ -f "$dir/Makefile" ]]; then
      sed -n '1,5p' "$dir/Makefile"
    fi
    echo "Device/SoC related files:"
    find "$dir/arch/arm64/boot/dts" "$dir/arch/arm64/configs" "$dir/drivers" "$dir" -type f \
      \( -iname '*rock*' -o -iname '*mt6789*' -o -iname '*mali*' -o -iname '*mediatek*' \) 2>/dev/null | sort -u | head -n 500 || true
    echo "Defconfigs:"
    find "$dir/arch/arm64/configs" -maxdepth 2 -type f 2>/dev/null | sort || true
    echo "DTS files:"
    find "$dir/arch/arm64/boot/dts" -type f 2>/dev/null | sort | grep -Ei 'rock|mt6789|mtk' | head -n 300 || true
  done
} > "$OUT/source-inventory.md"
echo "Audit report: $OUT/source-inventory.md"
