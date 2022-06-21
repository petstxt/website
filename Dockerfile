FROM alpine:latest
LABEL Mainainter="Chris <chris@chaoscontrol.org>" \
    Description="A lightweight and efficient Nginx container based on Alpine linux."

# Install core dependencies
RUN apk update && \
    apk upgrade && \
    apk add nginx \
    supervisor

# Set working directory
WORKDIR /var/www

# Configure supervisord
COPY .docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy app
COPY . ./

# Set user/group
RUN chown -R nobody.nobody /var/www

# Cleanup
RUN rm -rf /var/cache/apk/

# Expose NGINX on port 80
EXPOSE 80

# Start Nginx | FPM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
