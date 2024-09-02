#Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set timezone (important for some packages)
ARG TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN yes | unminimize

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
    sudo \
    autoconf \
    automake \
    autotools-dev \
    curl \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev

# Clone the RISC-V GNU Toolchain repository
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

# Build and install the RISC-V GNU Toolchain
RUN cd riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv --enable-multilib && \
    make -j$(nproc)

# Clean up to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf riscv-gnu-toolchain

# Create a user with sudo privileges
RUN useradd -ms /bin/bash xv6user && \
    echo 'xv6user:xv6user' | chpasswd && \
    adduser xv6user sudo

# Allow user to execute sudo commands without a password
RUN echo 'xv6user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the new user
USER xv6user

# Create the workspace directory
RUN mkdir -p /home/xv6user/workspace && \
    sudo chown -R xv6user:xv6user /home/xv6user

# Set the environment variables for the new user
ENV PATH="/opt/riscv/bin:${PATH}"

# Set the workspace directory as the working directory
WORKDIR /home/xv6user/workspace

# Install GDB Dashboard
RUN git clone https://github.com/cyrus-and/gdb-dashboard.git ~/.gdb-dashboard && \
    echo "source ~/.gdb-dashboard/.gdbinit" >> ~/.gdbinit

# Run a shell to keep the container running
CMD ["/bin/bash"]
