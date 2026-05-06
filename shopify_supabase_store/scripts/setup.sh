#!/usr/bin/env bash
set -euo pipefail

flutter pub get
cp -n assets/env/.env.example assets/env/.env || true
echo "Setup complete. Update assets/env/.env with real credentials."
