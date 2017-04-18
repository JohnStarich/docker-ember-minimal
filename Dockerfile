FROM smebberson/alpine-nginx-nodejs:4.2.2
MAINTAINER John Starich <john.starich@thirdship.com>

# Install and update certificates
RUN apk --update upgrade && apk add --no-cache curl ca-certificates && update-ca-certificates

# Configure nginx server for an Ember app
COPY default.conf /etc/nginx/conf.d/
# Add setup script to install everything, compile
#   with ember-cli, then remove all but the
#   compiled output.
COPY setup.sh /

# Add node user to install local dependencies
RUN adduser -D -u 1000 node
# Allow Ember to write output to nginx html directory
RUN chown -R node /usr/html/

ONBUILD ARG ENVIRONMENT
WORKDIR /src
ONBUILD COPY . /src
ONBUILD RUN sh /setup.sh
ONBUILD WORKDIR /usr/html/
