FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Make SSL directory
RUN mkdir -p /etc/nginx/ssl

# Copy nginx config and certs
COPY nginx/default.conf /etc/nginx/conf.d/
COPY ssl/selfsigned.crt /etc/nginx/ssl/selfsigned.crt
COPY ssl/selfsigned.key /etc/nginx/ssl/selfsigned.key

# Copy frontend build files
COPY frontend/dist /usr/share/nginx/html

# Expose HTTP and HTTPS
EXPOSE 80
EXPOSE 443

