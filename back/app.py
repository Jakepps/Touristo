from flask import Flask, jsonify
import json
import os

app = Flask(__name__)

def load_country_info(country_code):
    file_path = f'all_country_data/{country_code}.json'
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            country_info = json.load(file)
            return country_info
    else:
        return None

@app.route('/api/country/<country_code>', methods=['GET'])
def get_country_info(country_code):
    country_info = load_country_info(country_code)
    if country_info:
        return jsonify(country_info)
    else:
        return jsonify({'error': f'Information about the country with the {country_code} code was not found'}), 404

if __name__ == '__main__':
    app.run(debug=True)
