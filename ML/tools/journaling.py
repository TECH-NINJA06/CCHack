from groq import Groq
import os
from firebase_admin import firestore

groq_client = Groq(api_key=os.getenv("GROQ_API_KEY"))
db = firestore.client()

def update_state_from_journal(user_id: str, entry_id: str) -> dict:
    """
    Fetch journal entry from Firestore, analyze it with Groq, and update mental_state under user doc.
    Firestore structure:
    hackathons > CChack > users > {user_id} > journal > {entry_id}
    """
    # Path to journal entry
    doc_ref = db.collection("hackathons").document("CChack") \
                .collection("users").document(user_id) \
                .collection("journal").document(entry_id)

    # Get journal text
    doc = doc_ref.get()
    if not doc.exists:
        return {"error": f"Journal entry '{entry_id}' not found for user '{user_id}'."}

    journal_text = doc.to_dict().get("entry", "")
    if not journal_text.strip():
        return {"error": "Journal entry is empty."}

    # Groq Prompt
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

    # LLM call
    response = groq_client.chat.completions.create(
        model="mixtral-8x7b-32768",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,
        max_tokens=300,
    )

    # Parse and update
    state = eval(response.choices[0].message.content.strip())

    # Update user's mental_state
    user_ref = db.collection("hackathons").document("CChack") \
                 .collection("users").document(user_id)
    user_ref.update({"mental_state": state})

    return state
