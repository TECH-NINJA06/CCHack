# tools/cbt.py

from typing import Literal
import random
import os

# Optional Groq import
try:
    from groq import Groq
    groq_client = Groq(api_key=os.getenv("GROQ_API_KEY"))
    USE_GROQ = True
except ImportError:
    USE_GROQ = False

# Static CBT exercise bank
CBT_EXERCISES = {
    "anxiety": [
        "Write down your anxious thoughts and identify any cognitive distortions (e.g., catastrophizing).",
        "Practice deep breathing: Inhale for 4 seconds, hold for 4, exhale for 6. Repeat for 3 minutes.",
        "List 3 things that are in your control and 3 that are not.",
    ],
    "depression": [
        "Schedule one enjoyable activity today and reflect on how it made you feel afterward.",
        "Write a letter to yourself as if you were your best friend. Be kind.",
        "List 3 small wins from this week, even if they feel minor.",
    ],
    "stress": [
        "Write down the top 3 things causing you stress and brainstorm one small action for each.",
        "Do a 5-4-3-2-1 grounding exercise: name 5 things you see, 4 you feel, 3 you hear, 2 you smell, 1 you taste.",
        "Create a 'worry time' schedule — reserve 15 minutes just to think about worries.",
    ],
    "negative thoughts": [
        "Pick one recurring negative thought. Challenge it with evidence for and against.",
        "Transform a negative thought into a balanced one using the CBT thought record technique.",
        "Rate the intensity of a troubling thought from 1 to 10. Reflect on what lowers it.",
    ],
}


def get_cbt_exercise(topic: Literal["anxiety", "depression", "stress", "negative thoughts"], use_ai: bool = False) -> str:
    """
    Return a CBT exercise based on a topic. If use_ai=True and Groq is available, generate personalized advice.

    Args:
        topic (str): The mental health topic (e.g., "anxiety", "depression").
        use_ai (bool): Whether to generate a personalized CBT prompt using Groq LLM.

    Returns:
        str: CBT exercise prompt or suggestion
    """
    topic = topic.lower()

    if use_ai and USE_GROQ:
        try:
            chat_completion = groq_client.chat.completions.create(
                messages=[
                    {"role": "system", "content": "You are a licensed CBT therapist providing practical, safe and gentle CBT exercises."},
                    {"role": "user", "content": f"Give me one practical CBT exercise for someone dealing with {topic}."}
                ],
                model="mixtral-8x7b-32768",  # or use 'llama3-8b-8192'
                temperature=0.7,
                max_tokens=300,
            )
            return chat_completion.choices[0].message.content.strip()
        except Exception as e:
            return f"AI generation failed. Try static mode. ({str(e)})"

    # fallback to static
    if topic not in CBT_EXERCISES:
        return "Topic not recognized. Available: anxiety, depression, stress, negative thoughts."

    return random.choice(CBT_EXERCISES[topic])


# CLI test
if __name__ == "__main__":
    print(get_cbt_exercise("anxiety", use_ai=True))
