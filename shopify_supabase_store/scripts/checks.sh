#!/usr/bin/env bash
set -euo pipefail

dart format lib test scripts
flutter analyze
flutter test
