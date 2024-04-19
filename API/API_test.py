import os
import requests
import json

class CountryAPI:
    def __init__(self, api_key):
        self.base_url = 'https://countryapi.io/api/'
        self.api_key = api_key

    def get_all_countries(self):
        url = self.base_url + 'all'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_country_by_name(self, country_name):
        url = self.base_url + f'name/{country_name}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_country_by_capital(self, capital_name):
        url = self.base_url + f'capital/{capital_name}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_country_by_language(self, language_name):
        url = self.base_url + f'language/{language_name}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_countries_by_region(self, region_name):
        url = self.base_url + f'region/{region_name}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_countries_by_currency(self, currency_name):
        url = self.base_url + f'currency/{currency_name}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_countries_by_region_bloc(self, region_bloc):
        url = self.base_url + f'regionbloc/{region_bloc}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

    def get_country_by_calling_code(self, calling_code):
        url = self.base_url + f'callingcode/{calling_code}'
        headers = {'Authorization': f'Bearer {self.api_key}'}
        response = requests.get(url, headers=headers)
        return response.json()

api_key = 'ayu46LvG43NijUzW40n0IqclfDep5Q60NIO8LKeI'
country_api = CountryAPI(api_key)
api_folder = 'API'
if not os.path.exists(api_folder):
    os.makedirs(api_folder)

# Get all countries
all_countries = country_api.get_all_countries()
with open(os.path.join(api_folder,'all_country_info.json'), 'w') as f:
    json.dump(all_countries, f, indent=4)

# Get country by name
country_name = 'russia'
country_info = country_api.get_country_by_name(country_name)
with open(os.path.join(api_folder,'country_info.json'), 'w') as f:
    json.dump(country_info, f, indent=4)