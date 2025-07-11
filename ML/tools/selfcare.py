# tools/selfcare_ai.py

def generate_ai_recommendations(user_id: str, mental_state: dict) -> list[str]:
    """
    Use LLM to generate daily self-care suggestions from user's mental state.
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
"""

    response = groq_client.chat.completions.create(
        model="mixtral-8x7b-32768",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
        max_tokens=300,
    )

    suggestions = eval(response.choices[0].message.content.strip())
    db.collection("users").document(user_id).update({"today_recommendations": suggestions})
    return suggestions
