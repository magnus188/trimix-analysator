# Multi-stage Dockerfile for Trimix Analyzer
# Development: For testing only (no GUI)
# Production: Full GUI support for Raspberry Pi
FROM python:3.11-slim AS base

# Install system dependencies
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
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip

# Set labels for better image management
LABEL org.opencontainers.image.source="https://github.com/magnustrandokken/trimix-analysator"
LABEL org.opencontainers.image.description="Trimix Gas Analyzer for Raspberry Pi"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app

# Copy requirements first for better caching
COPY requirements*.txt ./

# Development stage (for testing only, no GUI)
FROM base AS development
RUN pip install -r requirements-dev.txt
ENV TRIMIX_ENVIRONMENT=development
ENV TRIMIX_MOCK_SENSORS=1

# Production stage (runs on RPi with full GUI support)
FROM base AS production
# Add GUI libraries for production
RUN apt-get update && apt-get install -y \
    libgpiod2 \
    gpiod \
    python3-libgpiod \
    # GUI libraries for Kivy
    libgl1-mesa-glx \
    libgles2-mesa \
    libegl1-mesa \
    libglfw3 \
    libglib2.0-0 \
    libxrandr2 \
    libxss1 \
    libxcursor1 \
    libxcomposite1 \
    libasound2 \
    libxi6 \
    libxtst6 \
    libgtk-3-0 \
    libxss1 \
    libgconf-2-4 \
    # X11 and SDL libraries
    xvfb \
    x11-utils \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libmtdev1 \
    libmtdev-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -r requirements-rpi.txt
# Install Kivy Garden graph widget using pip with git
RUN pip install https://github.com/kivy-garden/graph/archive/master.zip
ENV TRIMIX_ENVIRONMENT=production
ENV TRIMIX_MOCK_SENSORS=0

# Copy application code
COPY . .

# Add health check script
COPY scripts/healthcheck.py /usr/local/bin/healthcheck.py
RUN chmod +x /usr/local/bin/healthcheck.py

# Create non-root user for security
RUN useradd -m -u 1000 trimix && \
    chown -R trimix:trimix /app
USER trimix

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python /usr/local/bin/healthcheck.py

# Default command
CMD ["python", "main.py"]
