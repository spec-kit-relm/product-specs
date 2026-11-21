#!/usr/bin/env bash
# Clone every Relm repository as a sibling of product-specs (PS-4).
#   bash product-specs/workspace/clone-all.sh        (run from the parent folder, e.g. ~/relm)
set -euo pipefail
ORG="${ORG:-spec-kit-relm}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
for r in product-specs inventory-service orders-service web-storefront e2e-tests speckit-platform sdd-handbook; do
  if [ -d "$ROOT/$r/.git" ]; then
    echo "✓ $r (pulling)"; git -C "$ROOT/$r" pull --ff-only --quiet || true
  else
    echo "→ cloning $r"; git clone --quiet "https://github.com/$ORG/$r.git" "$ROOT/$r"
  fi
done
echo "Workspace ready in $ROOT — open product-specs/workspace/relm.code-workspace"
