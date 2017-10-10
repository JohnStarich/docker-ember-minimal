FROM alpine:3.4

# Install and update certificates
RUN apk add --no-cache \
        ca-certificates \
        curl \
        g++ \
        git \
        libstdc++ \
        make \
        nodejs \
        python \
        yarn \
        && \
    update-ca-certificates
RUN yarn install -g \
        bower \
        ember-cli \
        node-sass-prebuilt \
        phantomjs-prebuilt

# Configure nginx server for an Ember app
COPY default.conf /nginx/

RUN adduser -D -u 1000 node
RUN mkdir /src /html && \
    chown node /src /html
WORKDIR /src
USER node

# Copy dependency files for installation and
# cache the result as a few RUN layers.
ONBUILD COPY bower.json package.json /src/
ONBUILD RUN yarn install
ONBUILD RUN bower install
# Copy the whole app now for compilation
ONBUILD COPY . /src/
# Set the environment used when building the app
ONBUILD ARG ENVIRONMENT=production
# Compile and place distributable files in /html
ONBUILD RUN ember build \
                --environment "$ENVIRONMENT" \
                --output-path /html
