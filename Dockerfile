# Use an Ubuntu base image
FROM ubuntu:20.04

ARG BOARD
ARG PORT
ENV BOARD=$BOARD
ENV PORT=$PORT

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for the ESP-IDF
RUN apt-get update && apt-get install -y \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3.8-venv \
    python3-pip \
    python3-setuptools \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0 \
    pkg-config \
    && ln -s /usr/bin/python3 /usr/bin/python

# # Install ESP-IDF
# ENV IDF_PATH=/esp-idf
# RUN git clone --recursive https://github.com/espressif/esp-idf.git $IDF_PATH && \
#     cd $IDF_PATH && \
#     git checkout v5.1.2 && \
#     git submodule update --init --recursive

# RUN $IDF_PATH/install.sh && \
#     python3 -m pip install -r $IDF_PATH/tools/requirements/requirements.core.txt

# # Set up the environment variables
# ENV PATH="$IDF_PATH/tools:$PATH"

# Clone the MicroPython repository into the /micropython directory
WORKDIR /
RUN git clone --recurse-submodules https://github.com/micropython/micropython.git

RUN cd micropython && git checkout v1.22.0
# cd ./mpy-cross && make

# Set the working directory to the MicroPython ESP32 port directory
WORKDIR /micropython/ports/$PORT

# Build MicroPython for ESP32
# RUN make submodules
# RUN make USER_C_MODULES=../../../modules/micropython.cmake

# The default command can be to run a shell, replace this with your specific needs
# CMD ["/bin/bash", "-c", "source $IDF_PATH/export.sh && make -j$(nproc) BOARD=$BOARD"]
CMD ["/bin/bash", "-c", "make -j$(nproc) USER_C_MODULES=/modules && cp -r build-standard/* /root/build"]

# Reset the frontend to its original state
ENV DEBIAN_FRONTEND=









