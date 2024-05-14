import os
import re

# Read country codes from the text file
country_codes_file = 'country_codes.txt'
with open(country_codes_file, 'r') as f:
    country_codes = dict(re.findall(r"'(.*?)':\s*'(.*?)'", f.read()))

# Define the directory containing the JSON files
json_dir = 'json/transport'

# Function to shorten the country name if no code is found
def shorten_country_name(country):
    parts = country.split()
    if len(parts) > 1:
        return ''.join([part[0] for part in parts]).lower()
    return country[:2].lower()

# Get the list of JSON files in the directory
json_files = [f for f in os.listdir(json_dir) if f.endswith('.json')]

# Rename the JSON files based on the country codes or shortened name
for json_file in json_files:
    country_name = json_file[:-5]  # Remove the .json extension
    country_name_formatted = country_name.replace('_', ' ').title()  # Format to match the country codes
    country_code = country_codes.get(country_name_formatted, shorten_country_name(country_name_formatted))
    new_file_name = f"{country_code}.json"
    old_file_path = os.path.join(json_dir, json_file)
    new_file_path = os.path.join(json_dir, new_file_name)
    
    # Check if the new file path already exists
    if os.path.exists(new_file_path):
        print(f"File {new_file_path} already exists. Skipping renaming of {old_file_path}.")
    else:
        os.rename(old_file_path, new_file_path)
        print(f"Renamed {old_file_path} to {new_file_path}")
