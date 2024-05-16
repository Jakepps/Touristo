import os
import json

def load_country_codes(txt_file):
    with open(txt_file, 'r', encoding='utf-8') as file:
        content = file.read()
        content = content.replace('\n', '').replace(' ', '')
        country_codes = json.loads(f'{{{content}}}')
    return country_codes

def load_country_data(json_file):
    with open(json_file, 'r', encoding='utf-8') as file:
        country_data = json.load(file)
    return country_data

def rename_json_files(json_directory, country_codes, country_data):
    files = os.listdir(json_directory)
    no_code_countries = []
    
    # Создаем словарь для быстрого поиска кода страны по названию
    name_to_code = {data['name'].lower(): code for code, data in country_data.items()}

    for json_file in files:
        if json_file.endswith('.json'):
            country_name = os.path.splitext(json_file)[0].lower()
            # Переименовываем файл, если его название есть в словаре и если оно не совпадает с кодом
            if country_name in name_to_code:
                new_code = name_to_code[country_name]
                new_name = new_code + '.json'
                if json_file != new_name:
                    os.rename(os.path.join(json_directory, json_file), os.path.join(json_directory, new_name))
                    print(f'Renamed: {json_file} to {new_name}')
                else:
                    print(f'Skipped: {json_file} is already correctly named')
            else:
                no_code_countries.append(json_file)
                print(f'No code found for: {json_file}')

    # Записываем названия файлов без кода в файл nocode.txt
    with open('nocode.txt', 'w', encoding='utf-8') as nocode_file:
        for country in no_code_countries:
            nocode_file.write(f'{country}\n')

# Пример использования
json_directory = 'json/transport'  # Путь к директории с JSON файлами
txt_file = 'output.txt'  # Имя файла с кодами стран
json_file = 'all_country_data.json'  # Имя файла с данными о странах

country_codes = load_country_codes(txt_file)
country_data = load_country_data(json_file)
rename_json_files(json_directory, country_codes, country_data)
