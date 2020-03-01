#!/usr/bin/python3
# import the necessary packages
# from scipy.spatial import distance as dist
import numpy as np
import requests
import base64
import requests
import json
from phys_ref import phys_reference

key = 'AIzaSyAZgGSCnq98R4BefHgKfC2W90eBGt2uFfI'

def get_annotations_with_desc(response, desc):
    """
        get_annotations_with_desc : Gets any annotations with a matching description.
    """
    ones = []
    responses = response.get('responses', [])
    responses = filter(lambda x: x.get('textAnnotations', False), responses)
    for resp in responses:
        for annotation in resp.get('textAnnotations', []):
            actual = annotation.get('description', False)
            if desc in actual and len(actual) <= 5:
                ones.append(annotation)
    return ones


def get_annotation_length(annotation):
    """
        get the annotation length as a yardstick
    """
    verts = annotation.get('boundingPoly', {}).get('vertices', None)
    if verts is None:
        return 0
    x1 = verts[0].get('x', 0)
    x2 = verts[1].get('x', 0)
    x3 = verts[2].get('x', 0)

    y1 = verts[0].get('y', 0)
    y2 = verts[1].get('y', 0)
    y3 = verts[2].get('y', 0)

    d1 = np.sqrt(((x1-x2)**2)+((y1-y2)**2))
    d2 = np.sqrt(((x2-x3)**2)+((y2-y3)**2))

    if d1 > d2:
        return d1
    return d2


def get_largest_box(annotations):
    """
        get_largest_box() : Gets the largest bounding box of a group of annotations.
    """
    def get_box_area(annotation):
        """
            get_box_area() : Gets the box area of a single annotation
        """
        verts = annotation.get('boundingPoly', {}).get('vertices', None)
        if verts is None:
            return 0
        x1 = verts[0].get('x', 0)
        x2 = verts[1].get('x', 0)
        x3 = verts[2].get('x', 0)

        y1 = verts[0].get('y', 0)
        y2 = verts[1].get('y', 0)
        y3 = verts[2].get('y', 0)

        d1 = np.sqrt(((x1-x2)**2)+((y1-y2)**2))
        d2 = np.sqrt(((x2-x3)**2)+((y2-y3)**2))
        return d1*d2
    max_size = None
    num = 0
    for annotation in annotations:
        x = get_box_area(annotation)
        if x > num:
            num = x
            max_size = annotation
    return max_size


def get_image_measurement(image, filter_word, key):
    """
        get_image_measurement() : Get the measurement object given the text to find
    """
    user_img = base64.b64encode(image)
    request = {
    "requests": [
        {
        "image": {
            "content": user_img.decode('utf-8')
        },
        "features": [
            {
            "maxResults": 10,
            "type": "TEXT_DETECTION"
            },
        ]
        }
    ]
    }
    req_json = json.dumps(request)
    url = 'https://vision.googleapis.com/v1/images:annotate'
    params = {'key': key}
    headers = {'Content-type': 'application/json'}
    x = requests.post(url, params=params, headers=headers, data=req_json)
    texts = x.json()
    ones = get_annotations_with_desc(texts, filter_word)
    largest = get_largest_box(ones)
    proportion = 3/float(len(largest.get('description', 3))) #in case of extra (misread) letters.
    return (get_annotation_length(largest) - 15) * proportion #also get rid of 25 px of padding.


def get_ref_pix(image, denom):
    """
        get ref_pix based on bill
    """
    if denom == "1":
        return get_image_measurement(image, 'ONE', key)
    elif denom in ['5','10','20','50','100']:
        return get_image_measurement(image, 'DOLLARS', key)
    else:
        raise ValueError(f'Invalid denomination : {denom}')

def get_sizing_dict(image, four_dot):
    # if params_dict: 
    #     require_param = ['currency','denom']
    #     for param in require_param:
    #         if param not in params_dict:
    #             raise ValueError(f'Params mismatch: {param} not found')
    ph = phys_reference()
    ref_pix = get_ref_pix(image, '1')
    return ph.interpret_pix_size(ref_pix, 'USD', '1')
