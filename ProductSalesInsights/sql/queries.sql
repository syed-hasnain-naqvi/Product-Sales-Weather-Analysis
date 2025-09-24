-- ================================
-- Project 1: Product Sales Insights
-- Section A: SQL Queries
-- ================================

-- 1. Find the top 3 products with the highest total sales (based on units sold)
SELECT item_nbr, SUM(units) AS total_units
FROM train
GROUP BY item_nbr
ORDER BY total_units DESC
LIMIT 3;

-- 2. Join sales data (train) with the correct weather station using store_nbr
SELECT t.date, t.store_nbr, t.item_nbr, t.units,
       k.station_nbr, w.tavg, w.preciptotal, w.codesum
FROM train t
JOIN key k ON t.store_nbr = k.store_nbr
JOIN weather w ON k.station_nbr = w.station_nbr
AND t.date = w.date;

-- 3. Return daily sales and average temperature (tavg) for one of the top 3 products
-- Example: Product 5
SELECT t.date, t.item_nbr, SUM(t.units) AS daily_units, w.tavg
FROM train t
JOIN key k ON t.store_nbr = k.store_nbr
JOIN weather w ON k.station_nbr = w.station_nbr
AND t.date = w.date
WHERE t.item_nbr = 5
GROUP BY t.date, t.item_nbr, w.tavg
ORDER BY t.date;
