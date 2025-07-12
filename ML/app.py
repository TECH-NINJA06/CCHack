from flask import Flask, jsonify
import firebase_admin
from firebase_admin import credentials
from tools.selfcare import generate_selfcare_suggestions

# Init Flask
app = Flask(__name__)

# Init Firebase
cred = credentials.Certificate("firebasekey.json")
firebase_admin.initialize_app(cred)

@app.route("/suggestions", methods=["GET"])
def generate_and_store():
    suggestions = generate_selfcare_suggestions()
    return jsonify({"status": "success", "suggestions": suggestions})

if __name__ == "__main__":
    app.run(debug=True)
