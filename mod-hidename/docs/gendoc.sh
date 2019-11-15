#!/bin/bash

DOCS="$(dirname $(readlink -f $0))"
ROOT="$(dirname ${DOCS})"

CONFIG="${DOCS}/config.ld"

cd "${ROOT}"
rm -rf "${DOCS}/api.html" "${DOCS}/modules" "${DOCS}/scripts"
ldoc -B -c "${CONFIG}" -o "api" -d "${DOCS}" ./
