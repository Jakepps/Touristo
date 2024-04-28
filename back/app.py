from flask import Flask
from flask import jsonify
import json

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/api/country', methods=['GET'])
def get_country_info():
    with open('all_country_data.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    russia_info = data['ru']
    
    return jsonify(russia_info)

if __name__ == '__main__':
    app.run(debug=True)
