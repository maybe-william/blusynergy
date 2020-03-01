#!/usr/bin/python3
import os
from flask import jsonify, request, Flask
import json
import imgtosize
app = Flask(__name__)

def get_size(image):
    """
        get_sizes() : Given the image file, get the dimensions.
        For now a placeholder.
    """
    return imgtosize.get_size(image)


@app.route('/images/', methods=['POST'], strict_slashes=False)
def images():
    """
        images() : Receive the image and return the desired dimensions.
        For now return success or failure.
    """
    try:
        image = request.files['image']
        return jsonify(get_size(image.read())), 200
    except Exception as e:
        return f"An Error Occured: {e}"


port = int(os.environ.get('PORT', 8080))
if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=port)


