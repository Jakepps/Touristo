import json
import os
import jwt
import datetime
from flask import Flask, jsonify, send_from_directory, request, send_file
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
import matplotlib.pyplot as plt

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database_touristo.db'
app.config['UPLOAD_FOLDER'] = 'files/images_user'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(150), nullable=False)
    country_name = db.Column(db.String(150), nullable=False)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    image_path = db.Column(db.String(255), nullable=True)  
    
class FavoriteCountries(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    country_name = db.Column(db.String(150), nullable=False)
    country_code = db.Column(db.String(10), nullable=False)
    flag_path = db.Column(db.String(255), nullable=True)
    user = db.relationship('User', backref=db.backref('favorite_countries', lazy=True))

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
    new_user = User(full_name=full_name, 
                    country_name=country_name, 
                    username=username, 
                    email=email, 
                    password=hashed_password)
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
        token = jwt.encode({
            'user_id': user.id, 
            'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=24)
        },'aP3@f6Y^b2!d9V#g5H&m8L*z1C$q7Wj')
        return jsonify({"message": "Logged in successfully", "user_id": user.id, "token": token}), 200
    else:
        return jsonify({"error": "Invalid username or password"}), 401

@app.route("/userdata/<int:user_id>", methods=["GET"])
def get_user_data(user_id):
    user = User.query.get(user_id)
    if user:
        return jsonify({
            "full_name": user.full_name,
            "country_name": user.country_name,
            "username": user.username,
            "image_path": user.image_path
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
    
@app.route('/upload_image/<int:user_id>', methods=['POST'])
def upload_image(user_id):
    user = User.query.get(user_id)
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        user.image_path = '/files/user_photo/' + filename
        db.session.commit()
        return jsonify({'message': 'Image uploaded successfully', 'filepath': user.image_path}), 200
    return jsonify({'error': 'File not allowed'}), 400


@app.route('/files/user_photo/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

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
    
@app.route('/api/country/<country_code>/cities', methods=['GET'])
def get_cities_info(country_code):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 50, type=int)
    file_path = f'countries_cities/{country_code}.json'

    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            country_cities = json.load(file)
            total_cities = len(country_cities)
            start = (page - 1) * per_page
            end = start + per_page
            cities_info = country_cities[start:end]  

        return jsonify({
            'country_code': country_code,
            'total_cities': total_cities,
            'cities': cities_info,
            'page': page,
            'pages': (total_cities + per_page - 1) // per_page
        }), 200
    else:
        return jsonify({'error': f'Information about the country with the code {country_code} was not found'}), 404
    
@app.route('/api/country/<country_code>/count_cities', methods=['GET'])
def get_count_cities(country_code):
    file_path = f'countries_cities/{country_code}.json'
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            country_cities = json.load(file)
            cities_count = len(country_cities)
        return jsonify({'country_code': country_code, 'cities_count': cities_count}), 200
    else:
        return jsonify({'error': f'Information about the country with the code {country_code} was not found'}), 404
   
@app.route('/add_favorites/<int:user_id>/<country_code>', methods=['POST'])
def add_to_favorites(user_id, country_code):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    if FavoriteCountries.query.filter_by(user_id=user_id, country_code=country_code).first():
        return jsonify({"message": "Country already in favorites"}), 409
    
    country_info = load_country_info(country_code)
    if country_info:
        country_name = country_info[country_code]['translations']['rus']
        flag_path = country_info[country_code]['flag']['large']

    new_favorite = FavoriteCountries(user_id=user_id, 
                                     country_name=country_name, 
                                     country_code=country_code, 
                                     flag_path=flag_path)
    db.session.add(new_favorite)
    db.session.commit()
    return jsonify({"message": "Country added to favorites"}), 201

@app.route('/favorites/<int:user_id>', methods=['GET'])
def get_favorites(user_id):
    favorites = FavoriteCountries.query.filter_by(user_id=user_id).all()
    favorites_list = [
        {
            "country_code": f.country_code,
            "country_name": f.country_name,
            "flag_path": f.flag_path
        } for f in favorites
    ]
    return jsonify(favorites_list), 200

@app.route('/is_favorite/<int:user_id>/<country_code>', methods=['GET'])
def is_favorite(user_id, country_code):
    favorite = FavoriteCountries.query.filter_by(user_id=user_id, country_code=country_code).first()
    if favorite:
        return jsonify({"is_favorite": True}), 200
    else:
        return jsonify({"is_favorite": False}), 200

@app.route('/remove_favorites/<int:user_id>/<country_code>', methods=['DELETE'])
def remove_from_favorites(user_id, country_code):
    favorite = FavoriteCountries.query.filter_by(user_id=user_id, country_code=country_code).first()
    if favorite:
        db.session.delete(favorite)
        db.session.commit()
        return jsonify({"message": "Country removed from favorites"}), 200
    else:
        return jsonify({"error": "Favorite not found"}), 404

# Тур потоки
def load_arrivals_info(country_code):
    file_path = f'flows/arrivals/{country_code}.json'
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            employment_info = json.load(file)
            return employment_info
    else:
        return None
    
def load_employment_info(country_code):
    file_path = f'flows/employments/{country_code}.json'
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            employment_info = json.load(file)
            return employment_info
    else:
        return None
    
def load_tourismInd_data(country_code):
    file_path = f'flows/tourism_ind/{country_code}.json'
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            tourism_data = json.load(file)
            return tourism_data
    else:
        return None

def load_travel_data(country_code):
    file_path = f'flows/transport/{country_code}.json'
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            travel_data = json.load(file)
            return travel_data
    else:
        return None

@app.route('/api/flows/arrivals/<country_code>/<country_name>', methods=['GET'])
def get_arrivals_data(country_code, country_name):
    arrivals_info = load_arrivals_info(country_code)
    if arrivals_info:
        plot_path = generate_arrivals_plot(arrivals_info, country_code, country_name)
        return send_file(plot_path, mimetype='image/png')
    else:
        return jsonify({'error': f'Arrival data for the country with the ID {country_code} was not found'}), 404

@app.route('/api/flows/employment/<country_code>/<country_name>', methods=['GET'])
def get_employment_data(country_code, country_name):
    employment_info = load_employment_info(country_code)
    if employment_info:
        plot_path = generate_employment_plot(employment_info, country_code, country_name)
        return send_file(plot_path, mimetype='image/png')
    else:
        return jsonify({'error': f'Employment data for the country with the code {country_code} was not found'}), 404
    

@app.route('/api/flows/tourism_ind/<country_code>/<country_name>', methods=['GET'])
def get_tourismInd_data(country_code, country_name):
    tourism_data = load_tourismInd_data(country_code)
    if tourism_data:
        plot_path = generate_tourismInd_plot(tourism_data, country_code, country_name)
        return send_file(plot_path, mimetype='image/png')
    else:
        return jsonify({'error': f'Tourism ind data for the country with the code {country_code} was not found'}), 404

@app.route('/api/flows/tourism_ind2/<country_code>/<country_name>', methods=['GET'])
def get_tourismInd2_data(country_code, country_name):
    tourism_data = load_tourismInd_data(country_code)
    if tourism_data:
        plot_path = generate_tourismInd2_plot(tourism_data, country_code, country_name)
        return send_file(plot_path, mimetype='image/png')
    else:
        return jsonify({'error': f'Tourism ind2 data for the country with the code {country_code} was not found'}), 404

@app.route('/api/flows/transport/<country_code>/<country_name>', methods=['GET'])
def get_travel_data(country_code, country_name):
    travel_data = load_travel_data(country_code)
    if travel_data:
        plot_path = generate_travel_plot(travel_data, country_code, country_name)
        return send_file(plot_path, mimetype='image/png')
    else:
        return jsonify({'error': f'Travel data for the country with the code {country_code} was not found'}), 404

def generate_arrivals_plot(data, country_code, country_name):
    years = list(range(1995, 2022))
    total_arrivals = [data['Total'].get(str(year), 0) or 0 for year in years]
    overnight_visitors = [data['Overnights visitors (tourists)'].get(str(year), 0) or 0 for year in years]
    same_day_visitors = [data['Same-day visitors (excursionists)'].get(str(year), 0) or 0 for year in years]
    cruise_passengers = [data['of which, cruise passengers'].get(str(year), 0) or 0 for year in years]

    plt.figure(figsize=(10, 6))
    plt.plot(years, total_arrivals, label='Общее количество прибывших')
    plt.plot(years, overnight_visitors, label='Ночующие посетители (туристы)')
    plt.plot(years, same_day_visitors, label='Посетители в тот же день (экскурсанты)')
    plt.plot(years, cruise_passengers, label='Пассажиры круизных лайнеров')

    plt.xlabel('Год')
    plt.ylabel('Количество посетителей')
    plt.title(f'Количество посетителей в {country_name}')
    plt.legend()
    plt.grid(True)

    plot_path = f'temporary_plots/{country_code}_arrivals.png'
    plt.savefig(plot_path)
    #plt.close()
    return plot_path
  
def generate_employment_plot(data, country_code, country_name):
    years = list(range(1995, 2022))
    total_employment = [data['Total'].get(str(year), 0) or 0 for year in years]
    accommodation_services = [data['Accommodation services for visitors (hotels and similar establishments)'].get(str(year), 0) or 0 for year in years]
    other_accommodation = [data['Other accommodation services'].get(str(year), 0) or 0 for year in years]
    food_beverage = [data['Food and beverage serving activities'].get(str(year), 0) or 0 for year in years]
    passenger_transportation = [data['Passenger transportation'].get(str(year), 0) or 0 for year in years]
    travel_agencies = [data['Travel agencies and other reservation services activities'].get(str(year), 0) or 0 for year in years]
    other_tourism = [data['Other tourism industries'].get(str(year), 0) or 0 for year in years]

    plt.figure(figsize=(10, 6))
    plt.plot(years, total_employment, label='Общая численность сотрудников')
    plt.plot(years, accommodation_services, label='Услуги по размещению посетителей')
    plt.plot(years, other_accommodation, label='Другие услуги по размещению')
    plt.plot(years, food_beverage, label='Деятельность по подаче блюд и напитков')
    plt.plot(years, passenger_transportation, label='Пассажирские перевозки')
    plt.plot(years, travel_agencies, label='Туристические агентства и другие службы бронирования')
    plt.plot(years, other_tourism, label='Другие отрасли туризма')

    plt.xlabel('Год')
    plt.ylabel('Количество сотрудников')
    plt.title(f'Занятость в отраслях, связанных с туризмом, в {country_name}')
    plt.legend()
    plt.grid(True)

    plot_path = f'temporary_plots/{country_code}_employment.png'
    plt.savefig(plot_path)
    #plt.close()
    return plot_path

def generate_tourismInd_plot(data, country_code, country_name):
    years = list(range(1995, 2022))
    accommodation_for_visitors = [data['Accommodation for visitors in hotels and similar establishments'].get(str(year), 0) or 0 for year in years]
    number_of_establishments = [data['Number of establishments'].get(str(year), 0) or 0 for year in years]
    number_of_rooms = [data['Number of rooms'].get(str(year), 0) or 0 for year in years]
    number_of_bed_places = [data['Number of bed-places'].get(str(year), 0) or 0 for year in years]

    plt.figure(figsize=(10, 6))
    plt.plot(years, accommodation_for_visitors, label='Размещение для посетителей')
    plt.plot(years, number_of_establishments, label='Количество заведений')
    plt.plot(years, number_of_rooms, label='Количество комнат')
    plt.plot(years, number_of_bed_places, label='Количество спальных мест')

    plt.xlabel('Год')
    plt.ylabel('Значение')
    plt.title(f'Данные туристической индустрии для {country_name}')
    plt.legend()
    plt.grid(True)

    plot_path = f'temporary_plots/{country_code}_tourism_ind.png'
    plt.savefig(plot_path)
    #plt.close()
    return plot_path

def generate_tourismInd2_plot(data, country_code, country_name):
    years = list(range(1995, 2022))
    occupancy_rate_rooms = [data['Occupancy rate / rooms'].get(str(year), 0) or 0 for year in years]
    occupancy_rate_bed_places = [data['Occupancy rate / bed-places'].get(str(year), 0) or 0 for year in years]
    #average_length_of_stay = [data['Average length of stay'].get(str(year), 0) or 0 for year in years]

    plt.figure(figsize=(10, 6))
    plt.plot(years, occupancy_rate_rooms, label='Уровень заполняемости / Номеров')
    plt.plot(years, occupancy_rate_bed_places, label='Заполняемость / Койко-места')
    #plt.plot(years, average_length_of_stay, label='Средняя продолжительность пребывания')

    plt.xlabel('Год')
    plt.ylabel('Значение')
    plt.title(f'Данные туристической индустрии для {country_name}')
    plt.legend()
    plt.grid(True)

    plot_path = f'temporary_plots/{country_code}_tourism_ind2.png'
    plt.savefig(plot_path)
    #plt.close()
    return plot_path

def generate_travel_plot(data, country_code, country_name):
    years = list(range(1995, 2022))
    total = [data['Total'].get(str(year), 0) or 0 for year in years]
    air = [data['Air'].get(str(year), 0) or 0 for year in years]
    water = [data['Water'].get(str(year), 0) or 0 for year in years]
    land = [data['Land'].get(str(year), 0) or 0 for year in years]

    plt.figure(figsize=(10, 6))
    plt.plot(years, total, label='Общее')
    plt.plot(years, air, label='По воздуху')
    plt.plot(years, water, label='По воде')
    plt.plot(years, land, label='По суше')

    plt.xlabel('Год')
    plt.ylabel('Количество путешественников')
    plt.title(f'Количество пассажиров, путешествующих разными видами транспорта для {country_name}')
    plt.legend()
    plt.grid(True)

    plot_path = f'temporary_plots/{country_code}_transport.png'
    plt.savefig(plot_path)
    #plt.close()
    return plot_path

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    if not os.path.exists('temporary_plots'):
        os.makedirs('temporary_plots')
    app.run(debug=True)