# tools/mood_detector.py

from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import torch.nn.functional as F

# Load the model and tokenizer
tokenizer = AutoTokenizer.from_pretrained("ravi86/mood_detector")
model = AutoModelForSequenceClassification.from_pretrained("ravi86/mood_detector")

labels = ["happy", "sad", "angry", "neutral", "fear", "surprise", "disgust"]  

def detect_mood(text: str) -> dict:
    """
    Detects mood/emotion from a given text input using ravi86/mood_detector model.

    Args:
        text (str): The input text (e.g., journal entry or message)

    Returns:
        dict: Top mood label and confidence score
    """
    inputs = tokenizer(text, return_tensors="pt", truncation=True)

    with torch.no_grad():
        outputs = model(**inputs)
        logits = outputs.logits
        probs = F.softmax(logits, dim=1)

    # Get the index of the highest probability
    top_idx = torch.argmax(probs, dim=1).item()
    top_label = labels[top_idx]
    confidence = round(probs[0][top_idx].item(), 3)

    return {
        "mood": top_label,
        "confidence": confidence
    }

# Optional: CLI test
if __name__ == "__main__":
    test_input = "I feel like crying all the time and nothing makes me happy."
    result = detect_mood(test_input)
    print(f"Detected mood: {result['mood']} ({result['confidence'] * 100:.1f}%)")
