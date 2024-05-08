import json
import os
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database_touristo.db'
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(150), nullable=False)
    country_name = db.Column(db.String(150), nullable=False)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    full_name = data['full_name']
    country_name = data['country_name']
    username = data['username']
    email = data['email']
    password = data['password']

    if not all([full_name, country_name, username, email, password]):
        return jsonify({'error': 'All fields are required'}), 400

    if User.query.filter_by(username=username).first() is not None:
        return jsonify({'error': 'Username already exists'}), 409

    if User.query.filter_by(email=email).first() is not None:
        return jsonify({'error': 'Email already exists'}), 409

    hashed_password = generate_password_hash(password)
    new_user = User(full_name=full_name, country_name=country_name, username=username, email=email, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']

    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password, password):
        return jsonify({"message": "Logged in successfully", "user_id": user.id}), 200
    else:
        return jsonify({"error": "Invalid username or password"}), 401

@app.route("/userdata/<int:user_id>", methods=["GET"])
def get_user_data(user_id):
    user = User.query.get(user_id)
    if user:
        return jsonify({
            "full_name": user.full_name,
            "country_name": user.country_name,
            "username": user.username
        }), 200
    else:
        return jsonify({"error": "User not found"}), 404
    
@app.route("/update_user/<int:user_id>", methods=["POST"])
def update_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404
    
    data = request.get_json()
    try:
        full_name = data.get('full_name')
        country_name = data.get('country_name')
        if not full_name or not country_name:
            return jsonify({"error": "Missing full_name or country_name"}), 400
        
        user.full_name = full_name
        user.country_name = country_name
        db.session.commit()
        
        return jsonify({"message": "User updated successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

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
        return jsonify({'error': 'Information about the country with the code {country_code} was not found'}), 404

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
