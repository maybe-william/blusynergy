#!/usr/bin/python3
import os
from flask import jsonify, request, Flask
import json
import imgtosize as i2s
app = Flask(__name__)


def get_sizes(image):
    """
        get_sizes() : Given the image file, get the dimensions.
        For now a placeholder.
    """
    return i2s.get_sizes(image)


@app.route('/images/', methods=['POST'], strict_slashes=False)
def images():
    """
        images() : Receive the image and return the desired dimensions.
        For now return success or failure.
    """
    try:
        image = request.files['image']
        return jsonify(get_sizes(image)), 200
    except Exception as e:
        return f"An Error Occured: {e}"


port = int(os.environ.get('PORT', 8080))
if __name__ == '__main__':
    with open('prueba.jpg','rb') as x:
        image = x.read()
        i2s.get_size(image)
    # app.run(threaded=True, host='0.0.0.0', port=port)


