import express from "express";
import fetch from "node-fetch";
import cors from "cors";

const app = express();

app.use(cors());
app.use(express.json());

const API_KEY = process.env.GEMINI_API_KEY;

app.post("/askAI", async (req, res) => {
  const { prompt } = req.body;

  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
  contents: [{
    parts: [{
      text: `You are Luxi, a helpful project advisor.
Use this database to suggest projects: ${JSON.stringify(data || [])}
User question: ${userInput}`
    }]
  }]
}),
      }
    );

    const data = await response.json();

    const text =
      data?.candidates?.[0]?.content?.parts?.[0]?.text || "No response";

    res.json({ text });
  } catch (e) {
    res.status(500).json({ error: e.toString() });
  }
});

app.listen(3000, () =>
  console.log("Luxi backend running on port 3000")
);