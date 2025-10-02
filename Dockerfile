# ===========================
# Stage 1: Build dependencies
# ===========================
FROM python:3.10-slim as builder

# Set working directory
WORKDIR /app

# Install build tools (only needed in build stage, not in final image)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file
COPY requirements.txt .

# Install dependencies into a local user path
RUN pip install --user -r requirements.txt


# ===========================
# Stage 2: Final runtime image
# ===========================
FROM python:3.10-slim

WORKDIR /app

# Copy only the installed packages from builder
COPY --from=builder /root/.local /root/.local

# Add installed packages to PATH
ENV PATH=/root/.local/bin:$PATH

# Copy your app code
COPY . .

# Expose Flask port
EXPOSE 5000

# Run Flask app
CMD ["python", "app.py"]
