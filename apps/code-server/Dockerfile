FROM lscr.io/linuxserver/code-server:latest

# Install Python 3.13 from deadsnakes PPA (Ubuntu-based image)
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
        python3.13 \
        python3.13-venv \
        python3.13-dev \
        python3-pip && \
    # Set python3.13 as the default python3
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.13 1 && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

