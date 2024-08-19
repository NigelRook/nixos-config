#!/usr/bin/env bash

set -euo pipefail

set -x

device_path=$(colormgr get-devices | grep "Object Path:.*BOE_NE135A1M_NY1" | cut -c 16-)
profile_path=$(colormgr get-profiles | grep "Object Path:.*6cf5096a086792f1797bc4fa262bdfae" || true | cut -c 16-)

if [[ "$profile_path" == "" ]]; then
  profile_path=$(colormgr import-profile /home/nigel/nixos-config/home/files/Framework-13-2.8k.icm | grep "Object Path:" | cut -c 16-)
  sleep 10
  colormgr device-add-profile "$device_path" "$profile_path"
fi;

colormgr device-make-profile-default "$device_path" "$profile_path"
