#!/bin/sh
# Copyright 2023 logo-emojifier contributors
# Distributed under the terms of the GNU Affero General Public License v3.0 or later
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -eu

# Set NUM_PARALLEL_DOWNLOAD to `ceil(nproc / 2)` if not specified.
: ${NUM_PARALLEL_DOWNLOAD:="$(( ( `nproc` + 1 ) / 2 ))"}

cd "$(dirname "$(readlink -f "$0")")"
PROJ_ROOT="$(pwd)"

list_asset_conf() {
	find "${PROJ_ROOT}/assets" -mindepth 3 -maxdepth 3 -type f -iname asset.conf -print0
}

# Download all.
list_asset_conf | xargs --null --max-procs="$NUM_PARALLEL_DOWNLOAD" --max-args=1 helpers/dl.sh

# Generate all.
list_asset_conf | xargs --null --max-procs="$NUM_PARALLEL_DOWNLOAD" --max-args=1 helpers/generate.sh
