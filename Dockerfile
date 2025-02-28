# Use a compatible Debian ARM64 base image
FROM debian:bullseye

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Ensure system is updated and remove broken packages
RUN apt update && apt upgrade -y && \
    apt --fix-broken install && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Install required system dependencies with retry logic
RUN apt update && apt install -y --fix-missing \
    curl gnupg lsb-release udev python3 python3-pip \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Add Google Coral repository for TPU support
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update package lists again after adding Coral repo
RUN apt update && apt install -y \
    libedgetpu1-std \
    python3-tflite-runtime \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set up a working directory
WORKDIR /app

# Install additional Python libraries
RUN pip3 install --no-cache-dir edgetpuvision numpy

# Default command to start a bash shell
CMD ["/bin/bash"]