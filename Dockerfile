# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set timezone (important for some packages)
ARG TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#
RUN yes | unminimize
#
# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    build-essential \
    gdb-multiarch \
    qemu-system-misc \
    gcc-riscv64-linux-gnu \
    binutils-riscv64-linux-gnu \
    python3 \
    python3-pip \
    curl \
    vim \
    sudo

# Clean up to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user with sudo privileges
RUN useradd -ms /bin/bash user && \
    echo 'user:user' | chpasswd && \
    adduser user sudo

# Switch to the new user
USER user
WORKDIR /home/user

# Set the environment variables for the new user
ENV PATH="/usr/local/opt/riscv-gnu-toolchain/bin:${PATH}"

# Run a shell to keep the container running
CMD ["/bin/bash"]

