#!/usr/bin/python3
import os
from flask import jsonify, request, Flask
import json
import imgtosize
app = Flask(__name__)

@app.route('/images/', methods=['POST'], strict_slashes=False)
def images():
    """
        images() : Receive the image and return the desired dimensions.
        For now return success or failure.
    """
    try:
        image = request.files['image']
        sizing_dict = imgtosize.get_sizing_dict(image.read())
        return jsonify(sizing_dict), 200
    except Exception as e:
        raise f"An Error Occured: {e}"


port = int(os.environ.get('PORT', 8080))
if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=port)


