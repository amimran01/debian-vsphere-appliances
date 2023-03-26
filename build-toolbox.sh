#!/bin/sh

rm -rf output-debian-toolbox-*

packer build --on-error=ask -force \
    --var-file="debian-builder.json" \
    --var-file="debian-version-11.6.0.json" \
    debian-toolbox.json
