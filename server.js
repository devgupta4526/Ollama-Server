// server.js
import express from "express";
import bodyParser from "body-parser";
import { exec } from "child_process";

const app = express();
const PORT = process.env.PORT || 11434;

app.use(bodyParser.json());

// Optional: simple API key protection
const API_KEY = process.env.API_KEY || "supersecret"; 

app.post("/api/generate", (req, res) => {
  const { model, prompt, key } = req.body;

  // Check API key
  if (key !== API_KEY) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  if (!model || !prompt) {
    return res.status(400).json({ error: "Missing model or prompt" });
  }

  // Call Ollama CLI inside container
  // Example: ollama generate <model> "<prompt>"
  exec(`ollama generate ${model} "${prompt.replace(/"/g, '\\"')}"`, (error, stdout, stderr) => {
    if (error) {
      console.error("Ollama error:", error);
      return res.status(500).json({ error: "Ollama generation failed" });
    }

    res.json({ response: stdout.trim() });
  });
});

app.get("/", (req, res) => {
  res.send("Ollama Express server is running");
});

app.listen(PORT, () => {
  console.log(`Express wrapper listening on port ${PORT}`);
});
