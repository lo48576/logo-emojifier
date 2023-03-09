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
GENERATED_DIR="_generated/${ASSET_NAME}"
mkdir -p "${GENERATED_DIR}"

PREFIX="$(sh -c "set -eu ; source ${ASSET_CONF}"' ; echo $PREFIX')"
if [ -z "PREFIX" ] ; then
	echo "WARNING: prefix is empty or not set. Consult ${ASSET_CONF} ."
fi
DEST_PREFIX="$(readlink -f "$GENERATED_DIR")/${PREFIX}"
# Escape.
DEST_PREFIX="$(echo "$DEST_PREFIX" | sed -e 's/[]\$`(){};!><*?[]/\\&/g')"

pushd "${DOWNLOADS_DIR}" >/dev/null
# Run filter.
<"${ASSET_DIR}/filter.mgk.template" env DEST_PREFIX="$DEST_PREFIX" envsubst '${DEST_PREFIX}' | magick -script -
popd >/dev/null

if command -v oxipng >/dev/null ; then
	find "$GENERATED_DIR" -type f -iname '*.png' -execdir oxipng --quiet {} +
else if command -v optipng >/dev/null ; then
	find "$GENERATED_DIR" -type f -iname '*.png' -execdir oxipng --quiet {} +
fi
