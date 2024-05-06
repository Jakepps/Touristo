import json
import os
from googletrans import Translator

def translate_data(data, keys_to_translate, translator):
    for key in keys_to_translate:
        if key in data:
            if isinstance(data[key], str):
                translated_text = translator.translate(data[key], src='en', dest='ru').text
                data[key] = translated_text
            elif key == 'currencies' and isinstance(data[key], dict):
                for currency_code, currency_info in data[key].items():
                    if 'name' in currency_info and isinstance(currency_info['name'], str):
                        translated_name = translator.translate(currency_info['name'], src='en', dest='ru').text
                        currency_info['name'] = translated_name
    return data

def split_json_by_country(json_data):
    keys_to_translate = ['name', 'official_name', 'capital', 'region', 'subregion', 'language', 'currencies']
    country_codes = []
    translator = Translator()
    os.makedirs("countrys", exist_ok=True)  # Создание папки один раз

    with open("country_codes.txt", "w", encoding="utf-8") as codes_file:
        for country_code, country_data in json_data.items():
            file_path = f"countrys/{country_code}.json"
            # Проверка на существование файла
            if os.path.exists(file_path):
                continue  # Пропустить, если файл уже существует

            translated_data = translate_data(country_data, keys_to_translate, translator)
            country_name = translated_data['name']
            country_codes.append(f"'{country_name}': '{country_code}',")
            with open(file_path, "w") as outfile:
                json.dump({country_code: translated_data}, outfile, indent=4)
        # Запись всех кодов страны в файл
        codes_file.write("\n".join(country_codes))

def main():
    with open("all_country_info.json", "r") as infile:
        countries_json = json.load(infile)
        split_json_by_country(countries_json)

if __name__ == "__main__":
    main()
