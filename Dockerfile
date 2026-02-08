FROM python:3.9-slim

# Install system dependencies for WeasyPrint
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-xlib-2.0-0 \
    shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port that Streamlit will use
EXPOSE 8501

# Add and prepare custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    mkdir -p /var/log && touch /var/log/app.log

# Keep the custom entrypoint as the container's command
ENTRYPOINT ["/entrypoint.sh"]