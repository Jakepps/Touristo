import os
import json
import asyncio
import aiohttp
import aiofiles
from googletrans import Translator
import time

async def translate_city_names(directory):
    for filename in os.listdir(directory):
        if filename.endswith('.json'):
            file_path = os.path.join(directory, filename)
            start_time = time.time()
            await translate_file(file_path)
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"Перевод файла {filename} занял {elapsed_time:.2f} секунд.")
            break  # Завершаем работу после перевода одного файла

async def translate_file(file_path):
    translator = Translator()
    async with aiofiles.open(file_path, 'r', encoding='utf-8') as file:
        data = await file.read()
        cities = json.loads(data)
        tasks = [translate_city(city, translator) for city in cities]
        await asyncio.gather(*tasks)
        async with aiofiles.open(file_path, 'w', encoding='utf-8') as file:
            await file.write(json.dumps(cities, ensure_ascii=False, indent=4))

async def translate_city(city, translator):
    city_name = city['name']
    translated_name = translator.translate(city_name, src='en', dest='ru').text
    city['name'] = translated_name

# Укажите путь к директории с JSON файлами
directory = 'countries_cities'
asyncio.run(translate_city_names(directory))
