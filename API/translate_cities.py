import json
import os
import time
from translatepy import Translator
from concurrent.futures import ProcessPoolExecutor, as_completed
from tqdm import tqdm
import threading

translator = Translator()
cache = {}

def translate_city(city):
    if city in cache:
        return cache[city]
    translated_city = translator.translate(city, "ru").result
    cache[city] = translated_city
    return translated_city

def process_file(file_path):
    print(f"Processing {file_path} in thread {threading.current_thread().name}")
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            data = json.load(file)

        for city_info in data:
            if 'name' in city_info and isinstance(city_info['name'], str):
                city_info['name'] = translate_city(city_info['name'])

        with open(file_path, 'w', encoding='utf-8') as file:
            json.dump(data, file, ensure_ascii=False, indent=4)
    except Exception as e:
        print(f"Error processing file {file_path}: {e}")

def main(directory):
    start_time = time.time()
    print(f"Start time: {time.ctime(start_time)}")

    files = [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith('.json')]

    with ProcessPoolExecutor() as executor:
        futures = {executor.submit(process_file, file): file for file in files}
        for future in tqdm(as_completed(futures), total=len(futures)):
            try:
                future.result()
            except Exception as e:
                print(f"Error in future {futures[future]}: {e}")

    end_time = time.time()
    print(f"End time: {time.ctime(end_time)}")
    print(f"Total time taken: {end_time - start_time:.2f} seconds")


if __name__ == "__main__":
    main('countries_cities')
