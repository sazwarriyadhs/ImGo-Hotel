CREATE DATABASE imgohotel;

\c imgohotel;

-- USERS
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name TEXT,
email TEXT UNIQUE,
password TEXT
);

-- HOTEL
CREATE TABLE hotels (
id SERIAL PRIMARY KEY,
name TEXT,
location TEXT
);

CREATE TABLE rooms (
id SERIAL PRIMARY KEY,
hotel_id INT,
room_number TEXT,
status TEXT
);

CREATE TABLE reservations (
id SERIAL PRIMARY KEY,
user_id INT,
room_id INT,
check_in DATE,
check_out DATE
);

-- RESTAURANT
CREATE TABLE menus (
id SERIAL PRIMARY KEY,
name TEXT,
price NUMERIC
);

CREATE TABLE orders (
id SERIAL PRIMARY KEY,
total NUMERIC,
status TEXT
);

-- SPA
CREATE TABLE spa_services (
id SERIAL PRIMARY KEY,
name TEXT,
duration INT
);

-- PILATES
CREATE TABLE classes (
id SERIAL PRIMARY KEY,
name TEXT,
instructor TEXT,
schedule TIMESTAMP
);
