import json
import os

def split_json_by_country(json_data):
    country_codes=[]
    for country_code, country_data in json_data.items():
        file_name = f"all_country/{country_code}.json"
        country_codes.append(country_code)
        if not os.path.exists(file_name):
            with open(file_name, "w") as outfile:
                json.dump({country_code: country_data}, outfile, indent=4)
    with open("country_codes.txt", "w") as codes_file:
        codes_file.write(", ".join(country_codes))


def main():
    with open("all_country_info.json", "r") as infile:
        countries_json = json.load(infile)
        split_json_by_country(countries_json)

if __name__ == "__main__":
    main()
