#!/bin/bash
set -o errexit

cd /config

SHUTDOWN="$(curl -sS http://localhost:8500/v1/kv/$(hostname)/shutdown?raw)"

if [ "$SHUTDOWN" = "true" ]; then
    consul leave
else
    echo "Not shutting down, got message: $SHUTDONW"
fi
