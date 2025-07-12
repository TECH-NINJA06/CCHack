# update_state.py
import os
from groq import Groq
from firebase_admin import firestore

groq_client = Groq(api_key='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')
db = firestore.client()

def update_state_from_journal(user_id: str, entry_id: str) -> dict:
    """
    Fetch journal entry from Firestore, analyze it with Groq, and update mental_state.
    Firestore path: hackathons > CChack > journal > {entry_id}
    User path: hackathons > CChack > users > {user_id}
    """
    # Load journal entry from shared journal path (not under users anymore)
    doc_ref = db.collection("hackathons").document("CChack") \
        .collection("journal").document(entry_id)

    doc = doc_ref.get()
    if not doc.exists:
        return {"error": f"Journal entry '{entry_id}' not found."}

    journal_text = doc.to_dict().get("entry", "").strip()
    if not journal_text:
        return {"error": "Journal entry is empty."}

    prompt = f"""
You are a mental health assistant. Read the journal entry below and update the user's mental state as JSON.

Journal:
\"\"\"{journal_text}\"\"\"

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

    # Save state to user document
    user_ref = db.collection("hackathons").document("CChack") \
        .collection("users").document(user_id)

    user_ref.set({"mental_state": state}, merge=True)

    return state
