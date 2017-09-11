# Ember Minimal for Docker

Ember Minimal is a base image for Ember.js apps that automatically compiles the project at build-time. It is most useful in multi-stage builds where the output is copied into an nginx image (or similar).

```dockerfile
# Recommended Dockerfile format for projects that use this image
# Build the ember app using ONBUILD triggers:
FROM johnstarich/ember-minimal:2.0 as builder

# Begin an nginx image and copy the compiled output from the previous layer
FROM nginx
COPY --from=builder /html /usr/html
# Copy the provided nginx configuration files, for your convenience
COPY --from=builder /nginx /etc/nginx/conf.d
```

The primary goal is simplicity. Here is a 3-step quickstart guide:

1. Place the above Dockerfile snippet into your project.
2. Run `docker build`, optionally with a build arg for the environment: `--build-arg ENVIRONMENT=production`.
3. Start the fully-operational nginx server from the image you just built (e.g. `docker run`).

## Configuration

The primary way to change how your Ember app should be built is by changing the environment (i.e. `--build-arg ENVIRONMENT=???`). This defaults to `production` for simplicity's sake, but you can choose whichever environment you like. I use this to build my Ember apps with different API endpoints, all of which are set up inside the app's `config/environment.js`.

I've provided a working nginx config in `/nginx` that can be used as described in the quickstart guide. To configure nginx beyond the provided defaults, you can place additional configuration files into `/etc/nginx/conf.d/`.

### Deprecation Note

If you prefer to use a single FROM statement that builds and runs the app, follow the [old quickstart guide][] from version 1.2.

[old quickstart guide]: https://github.com/JohnStarich/docker-ember-minimal/blob/1.2/README.md
