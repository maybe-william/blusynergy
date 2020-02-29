from flask import Flask
from flask_restful import Api, Resource, reqparse
from flask import jsonify
import json

app = Flask(__name__)
api = Api(app)

# with open('sizes.json', 'rb') as data_file:    
#     sizes = json.load(data_file)


if __name__ == '__main__':
    print('s')
    with open('sizes.json', 'rb') as data_file:    
        sizes = json.load(data_file)
        print(sizes)