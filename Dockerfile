# Base Ollama image
FROM ollama/ollama

# Install Node.js (so Express can run)
RUN apt-get update && apt-get install -y nodejs npm

# Set working directory
WORKDIR /app

# Copy Express wrapper and dependencies
COPY server.js package*.json ./

# Install dependencies
RUN npm install express body-parser

# Expose port (Render expects this)
EXPOSE 11434

# Override Ollama entrypoint so we can run Node directly
ENTRYPOINT []

# Start the Express server
CMD ["node", "server.js"]
