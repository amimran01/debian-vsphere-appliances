#!/bin/sh

rm -rf output-debian-minimal-* 

packer build --on-error=ask -force \
    --var-file="debian-builder.json" \
    --var-file="debian-version-11.6.0.json" \
    debian-k8s.json
    
