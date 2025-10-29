# Grab a lightweight python image
FROM python:slim   

# Avoid file overwriting and buffering
ENV PYTHONDONTWRITEBYTECODE = 1 \
    PYTHONUNBUFFERED = 1

# App directory created 
WORKDIR /app

# Install dependencies  <<< lightGBM needs some extra dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgom1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Copy all code 
COPY . . 

# Install the other depencies as if using setup.py
RUN pip install --no-cache-dir -e .

# Train the whole model
RUN python pipeline/training_pipeline.py

# Expose the port for flask app
EXPOSE 5000 

# Run the app
CMD["python", "application.py"]