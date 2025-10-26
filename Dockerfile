FROM ollama/ollama

# Expose Ollama’s default port
EXPOSE 11434

# Start the Ollama server
CMD ["serve"]
