# Simple Dockerfile for Trimix Analyzer with GUI support
FROM python:3.11-slim

# Install system dependencies including minimal GUI libraries
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libi2c-dev \
    i2c-tools \
    python3-dev \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    libssl-dev \
    libatlas-base-dev \
    libgl1-mesa-glx \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libmtdev1 \
    libmtdev-dev \
    libxrandr2 \
    libxss1 \
    libxi6 \
    xvfb \
    x11-utils \
    libx11-dev \
    libxext-dev \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip

# Set labels for better image management
LABEL org.opencontainers.image.source="https://github.com/magnustrandokken/trimix-analysator"
LABEL org.opencontainers.image.description="Trimix Gas Analyzer for Raspberry Pi"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements*.txt ./
RUN pip install -r requirements-rpi.txt
RUN pip install https://github.com/kivy-garden/graph/archive/master.zip

# Set environment variables (can be overridden by docker-compose)
ENV TRIMIX_ENVIRONMENT=production
ENV TRIMIX_MOCK_SENSORS=0

# Copy application code
COPY . .

# Create non-root user for security and add to video group for framebuffer access
RUN useradd -m -u 1000 trimix && \
    usermod -a -G video trimix && \
    chown -R trimix:trimix /app
# USER trimix  # Comment out for now - run as root for framebuffer access

# Default command
CMD ["python", "main.py"]
