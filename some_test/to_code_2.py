import os
import json

def load_country_codes(txt_file):
    with open(txt_file, 'r', encoding='utf-8') as file:
        content = file.read()
        content = content.replace('\n', '')
        country_codes = json.loads(f'{{{content}}}')
    return country_codes

def load_country_data(json_file):
    with open(json_file, 'r', encoding='utf-8') as file:
        country_data = json.load(file)
    return country_data

def rename_json_files(json_directory, country_codes):
    files = os.listdir(json_directory)
    no_code_countries = []

    for json_file in files:
        if json_file.endswith('.json'):
            country_name = os.path.splitext(json_file)[0].lower()
            if country_name in country_codes:
                new_code = country_codes[country_name]
                new_name = new_code + '.json'
                new_path = os.path.join(json_directory, new_name)
                if json_file != new_name:
                    if not os.path.exists(new_path):
                        os.rename(os.path.join(json_directory, json_file), new_path)
                        print(f'Renamed: {json_file} to {new_name}')
                    else:
                        print(f'Skipped: {json_file} (target file {new_name} already exists)')
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
txt_file = 'add_code.txt'  # Имя файла с кодами стран

country_codes = load_country_codes(txt_file)
rename_json_files(json_directory, country_codes)
