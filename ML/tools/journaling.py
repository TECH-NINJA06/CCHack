from groq import Groq
import os
from firebase_admin import firestore  

groq_client = Groq(api_key=os.getenv("GROQ_API_KEY"))
db = firestore.client()

def update_state_from_journal(user_id: str, journal_text: str) -> dict:
    prompt = f"""
You are a mental health assistant. Read the journal entry below and update the user's mental state as JSON.

Journal:
\"\"\"
{journal_text}
\"\"\"

Output format:
{{
  "stress_level": "low|medium|high",
  "sleep_quality": "good|poor|average",
  "emotion_tendency": "anxious|sad|calm|happy|angry",
  "focus_issue": true|false
}}
Only output the JSON.
"""

    response = groq_client.chat.completions.create(
        model="mixtral-8x7b-32768",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,
        max_tokens=300,
    )

    state = eval(response.choices[0].message.content.strip())
    db.collection("users").document(user_id).update({"mental_state": state})
    return state
