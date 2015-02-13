#!/bin/bash
set -o errexit

cd /config

CURCOMMIT="$(git rev-parse HEAD)"
NEWCOMMIT="$(curl -sS http://localhost:8500/v1/kv/consul/commitish?raw)"

echo "Considering '$CURCOMMIT', '$NEWCOMMIT'"

if [ "$NEWCOMMIT" = "" -o "$NEWCOMMIT" = "No cluster leader" ]; then
    # Commit hash hasn't been put into kv store yet
    echo "Cluster not formed or no new commit set"
    exit 0
elif [ "${#CURCOMMIT}" != "${#NEWCOMMIT}" ]; then
    # A commit hash isn't the right length
    echo "Invalid commit hash length"
    exit 1
elif [ "$CURCOMMIT" = "$NEWCOMMIT" ]; then
    # Already on the commit
    echo "Already on correct commit"
    exit 0
else
    echo "Updating consul config"
    # These two are in case the initial build was a dirty git repo
    git clean -f -x -d
    git reset --hard
    # Upgrade consul config
    git fetch
    git checkout "$NEWCOMMIT"
    consul reload
fi
