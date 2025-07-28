FROM --platform=linux/amd64 python:3.11-alpine

# Set working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    poppler-utils \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create input and output directories
RUN mkdir -p /app/input /app/output

# Copy the application files
COPY Model_1b.py .
COPY process_pdfs.py .
COPY tinyllama-1.1b-chat-v1.0.Q4_0.gguf .

# Set environment variables
ENV MODEL_PATH=/app/tinyllama-1.1b-chat-v1.0.Q4_0.gguf
ENV PYTHONUNBUFFERED=1

# Make the scripts executable
RUN chmod +x Model_1b.py process_pdfs.py

# Default command to process all PDFs
ENTRYPOINT ["./process_pdfs.py"]
