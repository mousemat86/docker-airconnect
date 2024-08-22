# Use the smallest possible Debian-based image
FROM debian:bullseye-slim

# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    libssl3 \
    libssl-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install the latest AirConnect release
WORKDIR /opt/airconnect
RUN if [ "$ARCH_VAR" = "amd64" ]; then ARCH_VAR=linux-x86_64; elif [ "$ARCH_VAR" = "arm64" ]; then ARCH_VAR=linux-aarch64; elif [ "$ARCH_VAR" = "arm" ]; then ARCH_VAR=linux-arm; fi \
    && curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest | grep browser_download_url | cut -d '"' -f 4 | xargs curl -L -o airconnect.zip \
    && unzip airconnect.zip -d /opt/airconnect \
    && mv airupnp-$ARCH_VAR airupnp-docker \
    && mv aircast-$ARCH_VAR aircast-docker \
    && chmod +x airupnp-docker \
    && chmod +x aircast-docker

# Add entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
