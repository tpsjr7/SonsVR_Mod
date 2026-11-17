#!/usr/bin/env bash
# Steam launch options: /path/to/SonsVR_Mod/scripts/launch-wivrn.sh %command%
set -euo pipefail

if (( $# == 0 )); then
    echo "Usage: $0 <Steam game command and arguments>" >&2
    exit 2
fi

# Resolve the current deployment each launch so Flatpak updates keep working.
wivrn_root="$(flatpak info --show-location io.github.wivrn.wivrn)/files"
if [[ ! -f "$wivrn_root/xrizer/bin/linux64/vrclient.so" ||
      ! -f "$wivrn_root/share/openxr/1/openxr_wivrn.json" ]]; then
    echo "WiVRn's bundled xrizer or OpenXR manifest is missing." >&2
    exit 1
fi

export WINEDLLOVERRIDES="version=n,b${WINEDLLOVERRIDES:+;$WINEDLLOVERRIDES}"
export VR_OVERRIDE="$wivrn_root/xrizer"
export XR_RUNTIME_JSON="$wivrn_root/share/openxr/1/openxr_wivrn.json"
export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
export PRESSURE_VESSEL_FILESYSTEMS_RO="${PRESSURE_VESSEL_FILESYSTEMS_RO:+$PRESSURE_VESSEL_FILESYSTEMS_RO:}$wivrn_root"

exec "$@"
