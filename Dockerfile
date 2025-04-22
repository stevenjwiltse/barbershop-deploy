FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

# Copy frontend build files
COPY frontend/dist /usr/share/nginx/html
