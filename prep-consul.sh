#!/bin/bash
set -o errexit

sed -i 's/HOSTNAME/'"$(hostname)"'/g' consul.json
