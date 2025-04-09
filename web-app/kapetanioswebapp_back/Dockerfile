# Base image
FROM python:3.8.10-slim-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /code

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project
COPY . /code/

EXPOSE 8085
# Entrypoint command
CMD ["python", "manage.py", "runserver", "0.0.0.0:8085"]