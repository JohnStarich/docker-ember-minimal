#!/bin/sh

if [[ "$ENVIRONMENT" == "" ]]; then
    echo ENVIRONMENT build arg is required
    exit 2
fi

set -e # Exit if any return code is non-zero
set -x # Print every executed shell command

# Install temporary dependencies for compilable Ember dependencies
apk add --no-cache --virtual .build-deps \
    libstdc++ \
    python \
    make \
    g++ \
    git

# Install commonly used Ember.js dependencies and CLIs
npm install -g \
    phantomjs-prebuilt \
    node-gyp \
    bower \
    ember-cli

# Install npm and bower packages
chown -R node .
su -s /bin/sh node <<EOT
set -e
set -x
npm install
bower install

# Build Ember app
ember build \
    --environment "$ENVIRONMENT" \
    --output-path /usr/html/
EOT

# Remove build dependencies
npm uninstall -g \
    phantomjs-prebuilt \
    node-gyp \
    bower \
    ember-cli
apk del .build-deps
rm -rf "$PWD"
