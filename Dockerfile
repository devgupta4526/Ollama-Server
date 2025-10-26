FROM ollama/ollama

# Install Node.js (if not included)
RUN apt-get update && apt-get install -y nodejs npm

# Copy Express wrapper
WORKDIR /app
COPY server.js package*.json ./

# Install dependencies
RUN npm install express body-parser

# Expose port
EXPOSE 11434

# Start the Express server
CMD ["node", "server.js"]
