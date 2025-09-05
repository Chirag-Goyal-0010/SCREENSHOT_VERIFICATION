from flask import Flask, request, jsonify
import os, tempfile, numpy as np
from tensorflow.keras.applications.vgg16 import VGG16, preprocess_input
from tensorflow.keras.preprocessing import image as keras_image
from scipy.spatial.distance import cosine

app = Flask(__name__)

# Load VGG16 once
model = VGG16(weights='imagenet', include_top=False, pooling='avg')
print("✅ VGG16 loaded successfully")

def get_features(img_path):
    img = keras_image.load_img(img_path, target_size=(224, 224))
    x = keras_image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    return model.predict(x).flatten()

@app.route("/ping", methods=["GET"])
def ping():
    return jsonify({"status": "ok"})

@app.route("/vgg16", methods=["POST"])
def vgg16_compare():
    try:
        file1 = request.files.get('image1')
        file2 = request.files.get('image2')
        if not file1 or not file2:
            return jsonify({"error": "Provide both images"}), 400

        with tempfile.NamedTemporaryFile(delete=False) as t1, tempfile.NamedTemporaryFile(delete=False) as t2:
            file1.save(t1.name)
            file2.save(t2.name)

            feat1, feat2 = get_features(t1.name), get_features(t2.name)
            os.remove(t1.name)
            os.remove(t2.name)

        sim = 1 - cosine(feat1, feat2)
        decision = "accept" if sim >= 0.85 else "borderline" if sim >= 0.7 else "reject"

        return jsonify({
            "similarity": float(sim),
            "decision": decision
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)
