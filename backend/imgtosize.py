# import the necessary packages
# from scipy.spatial import distance as dist
import numpy as np
import requests
import base64
import requests
import json
import cv2 
from matplotlib import pyplot as plt

key = 'AIzaSyAZgGSCnq98R4BefHgKfC2W90eBGt2uFfI'

file_image = 'one_.jpg'
with open(file_image, "rb") as image_file:
    user_img = base64.b64encode(image_file.read())

request = {
"requests": [
    {
    "image": {
        "content": user_img.decode('utf-8')
    },
    "features": [
        {
        "maxResults": 10,
        "type": "OBJECT_LOCALIZATION"
        },
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

text_file = open(file_image, 'w+')
text_file.write(x.text)
print(list(filter(lambda x:x["id_number"]=="CZ1094",x.json)))


    # img = cv2.imread(str(i+1)+'.jpg',0)
    # edges = cv2.Canny(img,100,200)

    # plt.subplot(121),plt.imshow(img)
    # plt.title('Original Image'), plt.xticks([]), plt.yticks([])
    # plt.subplot(122),plt.imshow(edges,cmap = 'gray')
    # plt.title('Edge Image'), plt.xticks([]), plt.yticks([])

    # plt.show()