# Ember Minimal for Docker

Ember Minimal is a base image for Ember.js apps that automatically compiles the project and runs it with nginx.

The primary goal is simplicity, so the only required configuration is done in the Docker build step when choosing `--environment` for the Ember CLI. Here is a 3-step quickstart guide:

1. Place `FROM johnstarich/ember-minimal:1.1` in your Dockerfile.
2. Run `docker build` with the build arg for environment `--build-arg ENVIRONMENT=production`.
3. Start the fully functional nginx server.

## Additional configuration

To further configure nginx, you can place additional configuration files into `/etc/nginx/conf.d/`.
