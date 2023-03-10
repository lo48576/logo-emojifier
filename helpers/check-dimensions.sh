#!/bin/sh
# Copyright 2023 logo-emojifier contributors
# Distributed under the terms of the GNU Affero General Public License v3.0 or later
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -eu

IMG="$1"
EXPECTED_DIMS="${2:-$(echo "$IMG" | sed -ne 's:.*\.\([0-9x]*\)\.[^.]*$:\1:p')}"

ACTUAL_DIMS="$(magick identify -format '%wx%h' "$IMG")"
if [ "$ACTUAL_DIMS" != "$EXPECTED_DIMS" ] ; then
	echo "Unexpected image dimensions: expected=${EXPECTED_DIMS}, actual=${ACTUAL_DIMS}, file=${IMG}" >&2
	exit 1
fi
