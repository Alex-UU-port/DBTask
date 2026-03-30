SELECT 
    c.name AS car_name,
    c.class,
    cl.country,
    ROUND(AVG(r.position), 2) AS avg_position,
    COUNT(r.race) AS race_count
FROM Cars c
JOIN Results r ON c.name = r.car
JOIN Classes cl ON c.class = cl.class
GROUP BY c.name, c.class, cl.country
ORDER BY avg_position ASC, c.name ASC
LIMIT 1;