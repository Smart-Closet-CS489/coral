#Base image for Coral
FROM balenalib/raspberrypi4-64-debian:bullseye

#Dependencies
RUN apt update && apt install -y \
    python3 python3-pip \
    libedgetpu1-std \
    python3-tflite-runtime \
    udev \
    && rm -rf /var/lib/apt/lists/*

#Install Edge TPU API
RUN pip3 install --no-cache-dir edgetpuvision

#User permissions for USB access
RUN groupadd -r coral && usermod -aG coral root

#USB access
CMD ["/bin/bash"]
