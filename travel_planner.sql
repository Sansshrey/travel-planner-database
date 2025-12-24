CREATE DATABASE IF NOT EXISTS travel_planner_db;
USE travel_planner_db;

/* 
   Travel Planner Database Project
   Author: Sanskriti Shrey
   Description:
   SQL database to manage travel destinations, trips,
   and budgets with cost analysis using joins, aggregation,
   and sorting.
*/

-- =====================
-- Drop tables if exist
-- =====================
DROP TABLE IF EXISTS budgets;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS destinations;

-- =====================
-- Destinations Table
-- =====================
CREATE TABLE destinations (
    destination_id INT PRIMARY KEY,
    city VARCHAR(50),
    country VARCHAR(50),
    daily_cost INT
);

-- =====================
-- Trips Table
-- =====================
CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    destination_id INT,
    start_date DATE,
    end_date DATE,
    travelers INT,
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
);

-- =====================
-- Budgets Table
-- =====================
CREATE TABLE budgets (
    budget_id INT PRIMARY KEY,
    trip_id INT,
    transport_cost INT,
    accommodation_cost INT,
    food_cost INT,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

-- =====================
-- Insert Data
-- =====================

INSERT INTO destinations VALUES
(1, 'Delhi', 'India', 1500),
(2, 'Goa', 'India', 2500),
(3, 'Paris', 'France', 6000),
(4, 'Bangkok', 'Thailand', 3500);

INSERT INTO trips VALUES
(101, 1, '2025-01-10', '2025-01-15', 2),
(102, 2, '2025-02-05', '2025-02-10', 3),
(103, 3, '2025-03-01', '2025-03-07', 1),
(104, 4, '2025-04-12', '2025-04-18', 2);

INSERT INTO budgets VALUES
(201, 101, 3000, 6000, 4000),
(202, 102, 5000, 9000, 6000),
(203, 103, 20000, 15000, 8000),
(204, 104, 7000, 8000, 5000);

-- =========================================================
-- ANALYTICAL QUERIES
-- =========================================================

-- 1. Total cost per trip
SELECT 
    t.trip_id,
    d.city,
    d.country,
    (b.transport_cost + b.accommodation_cost + b.food_cost) AS total_trip_cost
FROM trips t
JOIN destinations d ON t.destination_id = d.destination_id
JOIN budgets b ON t.trip_id = b.trip_id;

-- 2. Most expensive trip
SELECT 
    t.trip_id,
    d.city,
    (b.transport_cost + b.accommodation_cost + b.food_cost) AS total_cost
FROM trips t
JOIN destinations d ON t.destination_id = d.destination_id
JOIN budgets b ON t.trip_id = b.trip_id
ORDER BY total_cost DESC
LIMIT 1;

-- 3. Budget-friendly trips (under 15000)
SELECT 
    t.trip_id,
    d.city,
    (b.transport_cost + b.accommodation_cost + b.food_cost) AS total_cost
FROM trips t
JOIN destinations d ON t.destination_id = d.destination_id
JOIN budgets b ON t.trip_id = b.trip_id
WHERE (b.transport_cost + b.accommodation_cost + b.food_cost) < 15000;

-- 4. Average trip cost by country
SELECT 
    d.country,
    AVG(b.transport_cost + b.accommodation_cost + b.food_cost) AS avg_trip_cost
FROM destinations d
JOIN trips t ON d.destination_id = t.destination_id
JOIN budgets b ON t.trip_id = b.trip_id
GROUP BY d.country;

-- 5. Trips sorted by duration
SELECT 
    t.trip_id,
    d.city,
    (t.end_date - t.start_date) AS trip_duration_days
FROM trips t
JOIN destinations d ON t.destination_id = d.destination_id
ORDER BY trip_duration_days DESC;
