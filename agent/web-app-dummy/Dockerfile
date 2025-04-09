# Use Ubuntu as base image
FROM python:3.12

# Set working directory
WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir fastapi uvicorn

# Copy source code
COPY . .

# Create ConfigMap directory
RUN mkdir -p /etc/config

EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]
