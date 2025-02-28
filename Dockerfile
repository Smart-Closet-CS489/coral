# Use a compatible Debian ARM64 base image
FROM debian:bullseye

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary system dependencies
RUN apt update && apt install -y \
    curl gnupg lsb-release udev python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Add Google Coral repository for Edge TPU libraries
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update package lists again after adding Coral repo
RUN apt update && apt install -y \
    libedgetpu1-std \
    python3-tflite-runtime \
    && rm -rf /var/lib/apt/lists/*

# Set up a working directory
WORKDIR /app

# Install additional Python libraries if needed
RUN pip3 install --no-cache-dir edgetpuvision numpy

# Default command to start a bash shell
CMD ["/bin/bash"]
