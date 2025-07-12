# app.py
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials
from update_state import update_state_from_journal
from tools.selfcare import generate_ai_recommendations

import os

app = Flask(__name__)

# Initialize Firebase Admin SDK
if not firebase_admin._apps:
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)

@app.route('/analyze_journal', methods=['GET'])
def analyze_journal():
    user_id = request.args.get('user_id')
    entry_id = request.args.get('entry_id')

    if not user_id or not entry_id:
        return jsonify({"error": "Missing user_id or entry_id"}), 400

    try:
        state = update_state_from_journal(user_id, entry_id)
        if "error" in state:
            return jsonify(state), 404

        # 🧠 Trigger self-care recommendation
        recommendations = generate_ai_recommendations(user_id, state)

        return jsonify({
            "mental_state": state,
            "recommendations": recommendations
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=8000)
