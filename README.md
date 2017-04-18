# Ember Minimal for Docker

Ember Minimal is a base image for Ember.js apps that automatically compiles the project at build-time and runs it with nginx.

The primary goal is simplicity. Here is a 3-step quickstart guide:

1. Place `FROM johnstarich/ember-minimal:1.2` in your Dockerfile.
2. Run `docker build`, optionally with a build arg for environment: `--build-arg ENVIRONMENT=production`.
3. Start the fully-operational nginx server from the image you just built (e.g. `docker run`).

## Configuration

The primary way to change how your Ember app should be built is by changing the environment (i.e. `--build-arg ENVIRONMENT=???`). This defaults to `production` for simplicity's sake, but you can choose whichever environment you like. I use this to build my Ember apps with different API endpoints, all of which are set up inside the app's `config/environment.js`.

To configure nginx beyond the provided defaults, you can place additional configuration files into `/etc/nginx/conf.d/`.
