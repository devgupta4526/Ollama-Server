# Base Ollama image (includes Ollama runtime)
FROM ollama/ollama

# Install Node.js and npm for Express
RUN apt-get update && apt-get install -y nodejs npm

# Set working directory
WORKDIR /app

# Copy the Express server and dependencies
COPY server.js package*.json ./

# Install dependencies
RUN npm install

# Expose port (Render expects this)
EXPOSE 11434

# Override Ollama's default entrypoint
ENTRYPOINT []

# Start Ollama in background, ensure model exists, then run Express
CMD bash -c "\
  echo '🚀 Starting Ollama...' && \
  ollama serve & \
  # Wait until Ollama is ready
  until ollama list > /dev/null 2>&1; do \
    echo '⏳ Waiting for Ollama to start...'; \
    sleep 2; \
  done && \
  # Ensure model is available
  if ! ollama list | grep -q 'codellama:7b'; then \
    echo '📦 Pulling CodeLlama model...'; \
    ollama pull codellama:7b; \
  fi && \
  echo '✅ Starting Express API...' && \
  node server.js"
