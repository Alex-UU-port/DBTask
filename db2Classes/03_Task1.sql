SELECT 
    c.class,
    c.name AS car_name,
    ROUND(AVG(r.position), 2) AS avg_position,
    COUNT(r.race) AS race_count
FROM Cars c
JOIN Results r ON c.name = r.car
GROUP BY c.class, c.name
HAVING AVG(r.position) = (
    SELECT MIN(avg_pos)
    FROM (
        SELECT AVG(r2.position) AS avg_pos
        FROM Cars c2
        JOIN Results r2 ON c2.name = r2.car
        WHERE c2.class = c.class
        GROUP BY c2.name
    ) AS sub
)
ORDER BY avg_position ASC;