CREATE DATABASE IF NOT EXISTS car_booking_db;
USE car_booking_db;

-- Table for Users
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role ENUM('customer', 'driver', 'admin') DEFAULT 'customer',
    rides INT DEFAULT 0,
    spent INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Cars
CREATE TABLE IF NOT EXISTS cars (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    seats INT NOT NULL,
    base_price INT NOT NULL,
    price_per_km INT NOT NULL,
    icon VARCHAR(50) NOT NULL
);

-- Table for Bookings
CREATE TABLE IF NOT EXISTS bookings (
    id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    pickup VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    car_id VARCHAR(50),
    car_name VARCHAR(100),
    total_price INT NOT NULL,
    distance FLOAT NOT NULL,
    status ENUM('pending', 'accepted', 'completed', 'cancelled') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid_card', 'paid_momo') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (car_id) REFERENCES cars(id)
);

-- Initial Data
INSERT IGNORE INTO users (id, name, email, password, role, rides, spent) VALUES 
('u1', 'John Doe', 'john@example.com', '123', 'customer', 47, 342),
('u2', 'Driver Bob', 'driver@example.com', '123', 'driver', 0, 0),
('u3', 'Admin Alice', 'admin@example.com', '123', 'admin', 0, 0);

INSERT IGNORE INTO cars (id, name, seats, base_price, price_per_km, icon) VALUES 
('normal', 'Normal', 4, 15000, 12000, 'car'),
('economy', 'Economy', 4, 12000, 10000, 'taxi'),
('premium', 'Comfort', 4, 20000, 15000, 'sedan'),
('van_xl', 'Van XL', 7, 25000, 18000, 'van');
