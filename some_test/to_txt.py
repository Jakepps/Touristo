import os

def write_json_filenames_to_txt(json_directory, output_file):
    # Получаем список файлов в директории
    files = os.listdir(json_directory)
    
    # Фильтруем только JSON файлы
    json_files = [f for f in files if f.endswith('.json')]
    
    # Открываем текстовый файл для записи
    with open(output_file, 'w', encoding='utf-8') as txt_file:
        for json_file in json_files:
            # Убираем расширение .json
            country_name = os.path.splitext(json_file)[0]
            # Записываем название файла в указанном формате
            txt_file.write(f'"{country_name}":""\n')


# Пример использования
json_directory = 'json/arrivals'  # Путь к директории с JSON файлами
output_file = 'output.txt'  # Имя выходного текстового файла

write_json_filenames_to_txt(json_directory, output_file)
