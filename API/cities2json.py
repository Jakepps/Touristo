import os
import json
import pandas as pd

file_path = 'cities.csv'
data = pd.read_csv(file_path)
data.head()

output_dir = 'countries_cities'
os.makedirs(output_dir, exist_ok=True)

grouped = data.groupby('country_code')

for country_code, group in grouped:
    cities_info = [
        {"name": row["name"], "latitude": row["latitude"], "longitude": row["longitude"]}
        for index, row in group.iterrows()
    ]
    
    json_file_path = os.path.join(output_dir, f"{country_code}.json")

    with open(json_file_path, 'w') as json_file:
        json.dump(cities_info, json_file, indent=4)

created_files = os.listdir(output_dir)
created_files[:10], len(created_files)