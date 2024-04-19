drop database if exists touristo_db;

CREATE DATABASE IF NOT EXISTS touristo_db;

USE touristo_db;

CREATE TABLE IF NOT EXISTS Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255),
  password_user VARCHAR(255) NOT NULL,
  email VARCHAR(255) unique,
  living_place VARCHAR(255),
  registration_date DATE
);

CREATE TABLE IF NOT EXISTS Countries (
  country_id INT AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(255),
  country_language VARCHAR(255),
  discription TEXT,
  travel_statistic TEXT,
  interesting_facts TEXT
);

CREATE TABLE IF NOT EXISTS FavoriteCountries (
  favorite_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  country_id INT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

DELIMITER //
create TRIGGER hash_password before insert on Users
for each row
begin 
	Set NEW.password_user = CONCAT('$2y$12$', substring(MD5(NEW.password_user), 1, 30));
end;
//
DELIMITER //
