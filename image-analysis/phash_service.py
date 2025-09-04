from flask import Flask, request, jsonify
from PIL import Image
import imagehash

app = Flask(__name__)

@app.route("/phash", methods=["POST"])
def compute_phash():
    file = request.files["file"]
    ref_file = request.files["reference"]

    img = Image.open(file)
    ref = Image.open(ref_file)

    hash1 = imagehash.phash(img)
    hash2 = imagehash.phash(ref)

    similarity = 100 - (abs(hash1 - hash2) / len(hash1.hash) ** 2 * 100)

    result = "borderline"
    if similarity >= 90:
        result = "accept"
    elif similarity < 50:
        result = "reject"

    return jsonify({
        "similarity": similarity,
        "decision": result
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)
