# Use an official Python runtime as a parent image on an amd64 platform
FROM --platform=linux/amd64 python:3.11-alpine

# Set the working directory in the container
WORKDIR /app

# 1. Install system dependencies using 'apk' (the Alpine package manager)
# 2. Add 'build-base' to install the C/C++ compilers (gcc, g++) needed for llama-cpp-python
RUN apk update && apk add --no-cache \
    build-base \
    cmake \
    tesseract-ocr \
    poppler-utils

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
# This command will now succeed because the compilers are available
RUN pip install --no-cache-dir -r requirements.txt

# Create input and output directories
RUN mkdir -p /app/input /app/output

# Copy the application files into the container
COPY Model_1b.py .
COPY process_pdfs.py .
COPY tinyllama-1.1b-chat-v1.0.Q4_0.gguf .

# Set environment variables
ENV MODEL_PATH=/app/tinyllama-1.1b-chat-v1.0.Q4_0.gguf
ENV PYTHONUNBUFFERED=1

# Make the scripts executable
RUN chmod +x Model_1b.py process_pdfs.py

# Set the entrypoint to run the processing script
ENTRYPOINT ["./process_pdfs.py"]