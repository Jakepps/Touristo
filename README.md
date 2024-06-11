# Touristo

## Описание
Это мобильное приложение предназначено для путешественников, предоставляющее информацию о различных странах, анализ туристических потоков и удобный доступ к персонализированным данным. Приложение разработано с использованием фреймворка Flutter, обеспечивающего кроссплатформенность и высокую производительность.

## Основные функции
- **Поиск информации о странах:** Получение детализированной информации о географии, культуре и экономике различных стран.
- **Аутентификация и авторизация:** Безопасная регистрация и вход в систему с помощью токенов JWT.
- **Личный кабинет:** Возможность редактирования персональных данных и управления списком избранных стран.
- **Добавление стран в избранное:** Легкий доступ к часто используемой информации о предпочитаемых странах.
- **Анализ данных туристических потоков:** Визуализация и анализ данных о туристических потоках, включая количество туристов, занятость в туристической отрасли и транспортные перемещения.

## Технологический стек
- **Flutter:** Для разработки кроссплатформенного мобильного приложения.
- **Dart:** Основной язык программирования для Flutter.
- **Python:** Для серверной части приложения.
- **Flask:** Фреймворк для создания API.
- **SQLite:** Реляционная база данных для хранения информации.

## Установка и запуск
1. **Клонируйте репозиторий:**
    ```sh
    git clone https://github.com/Jakepps/Touristo.git
    ```
2. **Перейдите в директорию проекта:**
    ```sh
    cd flutter_application_touristo
    ```
3. **Установите зависимости для Flutter:**
    ```sh
    flutter pub get
    ```
4. **Запустите приложение:**
    ```sh
    flutter run
    ```

## Серверная часть
1. **Перейдите в директорию серверной части:**
    ```sh
    cd back
    ```
2. **Создайте и активируйте виртуальное окружение:**
    ```sh
    python -m venv venv
    source venv/bin/activate (Linux/Mac)
    .\venv\Scripts\activate (Windows)
    ```
3. **Установите зависимости:**
    ```sh
    pip install -r requirements.txt
    ```
4. **Запустите сервер:**
    ```sh
    flask run
    ```

## Структура проекта
- `flutter_application_touristo/lib/`: Директория с исходным кодом Flutter приложения.
- `back/`: Директория с исходным кодом серверной части на Python.
- `flutter_application_touristo/assets/`: Директория с ресурсами (изображения, данные и т.д.).

## Вклад
Мы приветствуем вклад сообщества! Если вы хотите внести свой вклад в проект, пожалуйста, следуйте следующим шагам:
1. Форкните репозиторий.
2. Создайте новую ветку для ваших изменений.
3. Внесите изменения и сделайте коммит.
4. Откройте Pull Request для обсуждения и внесения изменений в основной проект.

## Контактная информация
Если у вас есть вопросы или предложения, пожалуйста, свяжитесь с нами по электронной почте: [nullexp.team@gmail.com](mailto:nullexp.team@gmail.com).

---

Наслаждайтесь использованием приложения и пусть ваши путешествия будут увлекательными и безопасными!