FROM smebberson/alpine-nginx-nodejs:4.2.2
MAINTAINER John Starich <john.starich@thirdship.com>

# Configure nginx server for an Ember app
COPY default.conf /etc/nginx/conf.d/

# Install and update certificates
RUN apk --update upgrade && apk add --no-cache curl ca-certificates && update-ca-certificates

# Add node user to install local dependencies
RUN adduser -D -u 1000 node
WORKDIR /src
RUN chown node /src
# Allow Ember to write output to nginx html directory
RUN chown -R node /usr/html/

USER root
# Install temporary dependencies for installing node-sass
RUN apk add --no-cache --virtual .build-deps \
        libstdc++ \
        python \
        make \
        g++ \
        git \
    && npm install -g \
        phantomjs-prebuilt \
        node-gyp \
        bower \
        ember-cli

# Install npm and bower packages
ONBUILD USER node
ONBUILD COPY package.json /src
ONBUILD RUN npm install
ONBUILD COPY bower.json /src
ONBUILD RUN bower install

# Build Ember app
ONBUILD ARG ENVIRONMENT
ONBUILD COPY . /src
ONBUILD RUN if [[ "$ENVIRONMENT" == "" ]]; then \
    echo ENVIRONMENT build arg is required; \
    exit 2; \
fi
ONBUILD RUN ember build --environment "$ENVIRONMENT" --output-path /usr/html/

# Reset to root user so nginx can start
ONBUILD USER root
# Remove build dependencies and source code
ONBUILD RUN rm -rf /src
ONBUILD RUN apk del .build-deps \
    && npm uninstall -g \
        phantomjs-prebuilt \
        node-gyp \
        bower \
        ember-cli
