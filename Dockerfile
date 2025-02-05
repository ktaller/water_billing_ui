# Flutter Build Stage
FROM ubuntu AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verify Flutter installation
RUN flutter doctor -v

# Set working directory
WORKDIR /app

# Copy Flutter dependencies
COPY pubspec.yaml pubspec.lock ./

# Fetch dependencies
RUN flutter pub get

# Copy the rest of the app files
COPY . .

# Build Flutter web app
RUN flutter build web

# Nginx Deployment Stage
FROM nginx:alpine AS production

# Copy built Flutter web files to Nginx HTML directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 for serving the app
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
