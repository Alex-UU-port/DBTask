WITH CarStats AS (
    SELECT 
        c.name,
        c.class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
ClassStats AS (
    SELECT 
        class,
        AVG(avg_position) AS class_avg_position,
        COUNT(*) AS car_count
    FROM CarStats
    GROUP BY class
    HAVING COUNT(*) >= 2
)
SELECT 
    cs.name AS car_name,
    cs.class,
    ROUND(cs.avg_position, 2) AS avg_position,
    cs.race_count,
    cs.country
FROM CarStats cs
JOIN ClassStats cl ON cs.class = cl.class
WHERE cs.avg_position < cl.class_avg_position
ORDER BY cs.class ASC, cs.avg_position ASC;