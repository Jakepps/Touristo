import json
import os

def split_json_by_country(json_data):
    country_codes = []
    with open("country_codes.txt", "w", encoding="utf-8") as codes_file:
        for country_code, country_data in json_data.items():
            file_path = f"countrys/{country_code}.json"
            country_name = country_data['name']
            country_codes.append(f"'{country_name}': '{country_code}',")
            if not os.path.exists(file_path):
                os.makedirs("countrys", exist_ok=True)  # Создание папки, если она не существует
                with open(file_path, "w") as outfile:
                    json.dump({country_code: country_data}, outfile, indent=4)
        # Запись всех кодов страны в файл
        codes_file.write("\n".join(country_codes))

def main():
    with open("all_country_info.json", "r") as infile:
        countries_json = json.load(infile)
        split_json_by_country(countries_json)

if __name__ == "__main__":
    main()
