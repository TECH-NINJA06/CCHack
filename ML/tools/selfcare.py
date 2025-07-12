from groq import Groq
from firebase_admin import firestore
import os

groq_client = Groq(api_key='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')
db = firestore.client()

def generate_selfcare_suggestions():
    """
    Generate and store 3 AI self-care suggestions under:
    hackathons > CChack > suggestions > 1, 2, 3 (as separate docs)
    """

    prompt = """
You are a mindfulness and wellness assistant. Suggest 3 helpful, practical self-care tips for the day.
Output only as a JSON array of strings. Example:

[
  "Drink a glass of water first thing in the morning.",
  "Take a 10-minute walk outdoors.",
  "Write down 3 things you're grateful for."
]
"""

    # Generate from LLM
    response = groq_client.chat.completions.create(
        model="mixtral-8x7b-32768",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
        max_tokens=300,
    )

    suggestions = eval(response.choices[0].message.content.strip())

    # Store each suggestion in a numbered doc (1, 2, 3)
    for i, tip in enumerate(suggestions, start=1):
        db.collection("hackathons").document("CChack") \
          .collection("suggestions").document(str(i)) \
          .set({"text": tip})

    return suggestions
