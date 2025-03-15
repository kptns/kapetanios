# Use Ubuntu as base image
FROM python:3.12

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/ src/

# Set default environment variables
ENV PYTHONUNBUFFERED=1
ENV CONFIGMAP_PATH=/etc/config

# Create ConfigMap directory
RUN mkdir -p /etc/config

# Command to run the application
CMD ["python", "src/run.py"]
