#!/bin/sh
# Copyright 2023 logo-emojifier contributors
# Distributed under the terms of the GNU Affero General Public License v3.0 or later
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -eu

ASSET_CONF="$1"
ASSET_CONF="$(readlink -f "$ASSET_CONF")"

cd "$(dirname "$(readlink -f "$0")")/.."

HELPERS_DIR="$(pwd)/helpers"
ASSET_DIR="$(readlink -f "$(dirname "$ASSET_CONF")")"
ASSET_NAME="$(realpath --relative-to=assets "$ASSET_DIR")"
DOWNLOADS_DIR="_downloaded/${ASSET_NAME}"

mkdir -p "${DOWNLOADS_DIR}"
cd "${DOWNLOADS_DIR}"

# Download.
curl --continue-at - --config "${ASSET_DIR}/curl-download.conf"

# Verify.
sha512sum --check "${ASSET_DIR}/downloads.sha512sum"

# Check if images have expected dimensions.
find . -type f -exec "${HELPERS_DIR}/check-dimensions.sh" {} \;
