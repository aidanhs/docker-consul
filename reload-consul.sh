#!/bin/bash
set -o errexit

cd /config

CURCOMMIT="$(git rev-parse HEAD)"
NEWCOMMIT="$(curl http://localhost:8500/v1/kv/consul/commitish?raw)"

echo "Considering '$CURCOMMIT', '$NEWCOMMIT'"

if [ "$NEWCOMMIT" = "" -o "$NEWCOMMIT" = "No cluster leader" ]; then
    # Commit hash hasn't been put into kv store yet
    exit 0
if [ "${#CURCOMMIT}" != "${#NEWCOMMIT}" ]; then
    # A commit hash isn't the right length
    exit 1
elif [ "$CURCOMMIT" = "$NEWCOMMIT" ]; then
    # Already on the commit
    exit 0
else
    # These two are in case the initial build was a dirty git repo
    git clean -f -x -d
    git reset --hard
    # Upgrade consul config
    git fetch
    git checkout "$NEWCOMMIT"
    consul reload
fi
