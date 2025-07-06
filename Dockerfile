# Optimized Dockerfile for Trimix Analyzer with GUI support
FROM python:3.11-slim

# Install system dependencies in optimized order (most stable packages first)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libi2c-dev \
    i2c-tools \
    python3-dev \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    libssl-dev \
    # Graphics libraries for hardware acceleration
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgles2-mesa \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    # Minimal X11 dependencies
    libx11-6 \
    libxext6 \
    libxi6 \
    libxrandr2 \
    libxss1 \
    # Input/touch support
    libmtdev1 \
    # Cleanup in same layer to reduce image size
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && pip install --no-cache-dir --upgrade pip

# Set labels for better image management
LABEL org.opencontainers.image.source="https://github.com/magnustrandokken/trimix-analysator"
LABEL org.opencontainers.image.description="Trimix Gas Analyzer for Raspberry Pi"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app

# Copy requirements and install Python dependencies with cache optimization
COPY requirements*.txt ./
RUN pip install --no-cache-dir -r requirements-rpi.txt \
    && pip install --no-cache-dir https://github.com/kivy-garden/graph/archive/master.zip

# Performance and graphics environment variables
ENV TRIMIX_ENVIRONMENT=production \
    TRIMIX_MOCK_SENSORS=0 \
    # Kivy optimizations
    KIVY_WINDOW=sdl2 \
    KIVY_GL_BACKEND=gl \
    KIVY_DPI=96 \
    KIVY_METRICS_DENSITY=1 \
    # Graphics optimizations - try hardware first, fallback to software
    LIBGL_ALWAYS_INDIRECT=0 \
    MESA_GL_VERSION_OVERRIDE=3.3 \
    # Memory and performance
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # Disable unnecessary services
    DEBIAN_FRONTEND=noninteractive

# Copy application code
COPY . .

# Create non-root user for security and add to video group for framebuffer access
RUN useradd -m -u 1000 trimix && \
    usermod -a -G video trimix && \
    chown -R trimix:trimix /app
# USER trimix  # Comment out for now - run as root for framebuffer access

# Default command
CMD ["python", "main.py"]
