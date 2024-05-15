import os
import pandas as pd
import json
import re

# Load the data from the CSV file
file_path = 'Inbound Tourism-Transport.csv'  # Update with the actual file path

# Create directory if it does not exist
output_dir = 'transport'
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Read CSV file
df = pd.read_csv(file_path, delimiter=';', header=None)

# Process the data
countries = ["AFGHANISTAN", "ALBANIA", "ALGERIA", "AMERICAN SAMOA", "ANDORRA", "ANGOLA", "ANGUILLA", "ANTIGUA AND BARBUDA", 
            "ARGENTINA", "ARMENIA", "ARUBA", "AUSTRALIA", "AUSTRIA", "AZERBAIJAN", "BAHAMAS", "BAHRAIN", "BANGLADESH", "BARBADOS", 
            "BELARUS", "BELGIUM", "BELIZE", "BENIN", "BERMUDA", "BHUTAN", "BOLIVIA, PLURINATIONAL STATE OF", "BONAIRE", "BOSNIA AND HERZEGOVINA", 
            "BOTSWANA", "BRAZIL", "BRITISH VIRGIN ISLANDS", "BRUNEI DARUSSALAM", "BULGARIA", "BURKINA FASO", "BURUNDI", "CABO VERDE", "CAMBODIA", 
            "CAMEROON", "CANADA", "CAYMAN ISLANDS", "CENTRAL AFRICAN REPUBLIC", "CHAD", "CHILE", "CHINA", "COLOMBIA", "COMOROS", "CONGO", 
            "CONGO, DEMOCRATIC REPUBLIC OF THE", "COOK ISLANDS", "COSTA RICA", "COTE DIVOIRE", "CROATIA", "CUBA", "CURAAO", "CYPRUS", 
            "CZECH REPUBLIC (CZECHIA)", "DENMARK", "DJIBOUTI", "DOMINICA", "DOMINICAN REPUBLIC", "ECUADOR", "EGYPT", "EL SALVADOR", 
            "EQUATORIAL GUINEA", "ERITREA", "ESTONIA", "ESWATINI", "ETHIOPIA", "FIJI", "FINLAND", "FRANCE", "FRENCH GUIANA", "FRENCH POLYNESIA", 
            "GABON", "GAMBIA", "GEORGIA", "GERMANY", "GHANA", "GREECE", "GRENADA", "GUADELOUPE", "GUAM", "GUATEMALA", "GUINEA", "GUINEA-BISSAU", 
            "GUYANA", "HAITI", "HONDURAS", "HONG KONG, CHINA", "HUNGARY", "ICELAND", "INDIA", "INDONESIA", "IRAN, ISLAMIC REPUBLIC OF", "IRAQ", 
            "IRELAND", "ISRAEL", "ITALY", "JAMAICA", "JAPAN", "JORDAN", "KAZAKHSTAN", "KENYA", "KIRIBATI", "KOREA, DEMOCRATIC PEOPLES REPUBLIC OF", 
            "KOREA, REPUBLIC OF", "KUWAIT", "KYRGYZSTAN", "LAO PEOPLES DEMOCRATIC REPUBLIC", "LATVIA", "LEBANON", "LESOTHO", "LIBERIA", "LIBYA",
            "LIECHTENSTEIN", "LITHUANIA", "LUXEMBOURG", "MACAO, CHINA", "MADAGASCAR", "MALAWI", "MALAYSIA", "MALDIVES", "MALI", "MALTA", 
            "MARSHALL ISLANDS", "MARTINIQUE", "MAURITANIA", "MAURITIUS", "MEXICO", "MICRONESIA, FEDERATED STATES OF", "MOLDOVA, REPUBLIC OF", "MONACO", 
            "MONGOLIA", "MONTENEGRO", "MONTSERRAT", "MOROCCO", "MOZAMBIQUE", "MYANMAR", "NAMIBIA", "NAURU", "NEPAL", "NETHERLANDS", "NEW CALEDONIA",
            "NEW ZEALAND", "NICARAGUA", "NIGER", "NIGERIA", "NIUE", "NORTH MACEDONIA", "NORTHERN MARIANA ISLANDS", "NORWAY", "OMAN",
            "PAKISTAN", "PALAU", "PANAMA", "PAPUA NEW GUINEA", "PARAGUAY", "PERU", "PHILIPPINES", "POLAND", "PORTUGAL", "PUERTO RICO",
            "QATAR", "REUNION", "ROMANIA", "RUSSIAN FEDERATION", "RWANDA", "SABA", "SAINT KITTS AND NEVIS", "SAINT LUCIA",
            "SAINT VINCENT AND THE GRENADINES", "SAMOA", "SAN MARINO", "SAO TOME AND PRINCIPE", "SAUDI ARABIA", "SENEGAL",
            "SERBIA", "SERBIA AND MONTENEGRO", "SEYCHELLES", "SIERRA LEONE", "SINGAPORE", "SINT EUSTATIUS", "SINT MAARTEN (DUTCH PART)",
            "SLOVAKIA", "SLOVENIA", "SOLOMON ISLANDS", "SOMALIA", "SOUTH AFRICA", "SOUTH SUDAN", "SPAIN", 
            "SRI LANKA", "STATE OF PALESTINE", "SUDAN", "SURINAME", "SWEDEN", "SWITZERLAND", "SYRIAN ARAB REPUBLIC", 
            "TAIWAN PROVINCE OF CHINA", "TAJIKISTAN", "TANZANIA, UNITED REPUBLIC OF", "THAILAND", "TIMOR-LESTE",
            "TOGO", "TONGA", "TRINIDAD AND TOBAGO", "TUNISIA", "TURKIYE", "TURKMENISTAN", "TURKS AND CAICOS ISLANDS",
            "TUVALU", "UGANDA", "UKRAINE", "UNITED ARAB EMIRATES", "UNITED KINGDOM", "UNITED STATES OF AMERICA", 
            "UNITED STATES VIRGIN ISLANDS", "URUGUAY", "UZBEKISTAN", "VANUATU", "VENEZUELA, BOLIVARIAN REPUBLIC OF", "VIET NAM", 
            "YEMEN", "ZAMBIA", "ZIMBABWE"]

years = list(range(1995, 2022))
categories = [
    "Total",
    "Air",
    "Water",
    "Land"
]

# Find the starting indices of each country
country_indices = {country: df[df[0] == country].index[0] for country in countries}

# Function to extract data for a given country and category
def extract_data(country, category, start_index, category_index):
    data = {}
    for year in years:
        year_index = 4 + (year - 1995)  # Update the index to match the CSV structure
        value = df.iloc[start_index + category_index, year_index]
        # Clean value and convert to the appropriate type if possible
        if pd.isna(value) or value == "..":
            data[year] = None
        else:
            # Remove any spaces or commas from the values
            value = re.sub(r'[ ,]', '', str(value))
            try:
                data[year] = float(value) if '.' in value else int(value)
            except ValueError:
                data[year] = value
    return data

# Process each country and write to a JSON file
for country in countries:
    start_index = country_indices[country]
    country_data = {}

    for i, category in enumerate(categories):
        country_data[category] = extract_data(country, category, start_index, i + 2)

    # Write to JSON file
    json_file_path = os.path.join(output_dir, f'{country.lower()}.json')
    with open(json_file_path, 'w', encoding='utf-8') as json_file:
        json.dump(country_data, json_file, ensure_ascii=False, indent=4)

    print(f'Data for {country} written to {json_file_path}')
