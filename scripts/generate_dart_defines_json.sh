#!/bin/bash
# Writes dart_defines.json next to pubspec.yaml for --dart-define-from-file (Flutter 3.16+).
set -e
cd "$(dirname "$0")/.."
python3 <<'PY'
import json
from pathlib import Path

root = Path(".")
env_path = root / ".env"
out_path = root / "dart_defines.json"

keys = (
    "SHOPIFY_DOMAIN",
    "SHOPIFY_STOREFRONT_TOKEN",
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "SUPABASE_EMAIL_REDIRECT",
)

env: dict[str, str] = {}
if env_path.is_file():
    for raw in env_path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        k, v = line.split("=", 1)
        k = k.strip()
        v = v.strip().strip('"').strip("'")
        env[k] = v

payload = {k: env.get(k, "") for k in keys}
out_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
print(f"Wrote {out_path} ({len(payload)} keys)")
PY
