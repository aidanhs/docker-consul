#!/bin/bash
set -o errexit

cd /config

sed -i 's/HOSTNAME/'"$(hostname)"'/g' consul.json
