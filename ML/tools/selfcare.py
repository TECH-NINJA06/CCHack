# tools/selfcare_ai.py
from firebase_admin import firestore
from groq import Groq
import os

groq_client = Groq(api_key='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')
db = firestore.client()

def generate_ai_recommendations(user_id: str, mental_state: dict) -> list[str]:
    """
    Use Groq LLM to generate 3 personalized self-care suggestions.
    Saves them under users/{user_id}/today_recommendations.
    """

    prompt = f"""
You are a mindfulness and wellness assistant. Based on the mental state JSON below, generate 3 personalized self-care suggestions for the user.

Mental State:
{mental_state}

Example format:
[
  "Try a short guided meditation for anxiety.",
  "Listen to a calming soundscape before sleep.",
  "Set a hydration reminder every 2 hours."
]
Only return the JSON list. No explanation.
"""

    try:
        response = groq_client.chat.completions.create(
            model="mixtral-8x7b-32768",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7,
            max_tokens=300,
        )

        # Safely parse suggestions
        raw_output = response.choices[0].message.content.strip()
        suggestions = eval(raw_output)

        if not isinstance(suggestions, list):
            raise ValueError("Groq did not return a valid list")

        # Save to Firestore under the user
        db.collection("users").document(user_id).update({
            "today_recommendations": suggestions
        })

        return suggestions

    except Exception as e:
        print(f"[ERROR] Failed to generate AI recommendations: {e}")
        return []
