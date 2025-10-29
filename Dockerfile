# syntax=docker/dockerfile:1
# or 3.13-slim if you prefer
FROM python:3.11-slim    

# No spaces around '=' for ENV
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# LightGBM needs libgomp1 (note the 'p')
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy your project into the image
COPY . .

# Install your package (editable ok for dev; for prod usually not -e)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -e .

# Expose Flask port (if your app really listens on 5000)
EXPOSE 5000

# If you really want to train during container run, do it in ENTRYPOINT/CMD of a training image,
# not during 'docker build'. For now just run the app:
CMD ["python", "application.py"]
