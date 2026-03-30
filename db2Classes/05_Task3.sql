WITH ClassStats AS (
    SELECT 
        c.class,
        AVG(r.position) AS class_avg_position
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
),
MinClass AS (
    SELECT MIN(class_avg_position) AS min_avg
    FROM ClassStats
),
CarsStats AS (
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
)
SELECT 
    cs.name AS car_name,
    cs.class,
    cs.avg_position,
    cs.race_count,
    cs.country,
    (
        SELECT COUNT(*)
        FROM Cars c2
        JOIN Results r2 ON c2.name = r2.car
        WHERE c2.class = cs.class
    ) AS total_races_in_class
FROM CarsStats cs
JOIN ClassStats clst ON cs.class = clst.class
JOIN MinClass mc ON clst.class_avg_position = mc.min_avg
ORDER BY cs.class, cs.name;