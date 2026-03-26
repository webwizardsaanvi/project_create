import express from "express";
import fetch from "node-fetch";
import cors from "cors";

const app = express();
app.use(cors({
  origin: '*', 
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

app.post("/askAI", async (req, res) => {
  const { userInput, data } = req.body;
  const apiKey = "AIzaSyCv7bdqLvCTTe6pCqfwNfJ7Jh6m7dtUttc"; // Hide this in .env later!

  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{
            parts: [{
              text: `You are Dewey, a helpful project advisor. 
                     Use this database to suggest 3 projects: ${JSON.stringify(data)} 
                     User question: ${userInput}`
            }]
          }]
        }),
      }
    );

    const aiData = await response.json();
    res.json(aiData); 
  } catch (e) {
    res.status(500).json({ error: e.toString() });
  }
});

app.listen(3000, () => console.log("Dewey Backend running on port 3000"));