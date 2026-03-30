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
LowCars AS (
    SELECT *
    FROM CarStats
    WHERE avg_position > 3.0
),
ClassLowCount AS (
    SELECT 
        class,
        COUNT(*) AS low_car_count
    FROM LowCars
    GROUP BY class
),
MaxClass AS (
    SELECT MAX(low_car_count) AS max_count
    FROM ClassLowCount
)
SELECT 
    cs.name AS car_name,
    cs.class,
    ROUND(cs.avg_position, 2) AS avg_position,
    cs.race_count,
    cs.country,
    clc.low_car_count,
    (
        SELECT COUNT(*)
        FROM Cars c2
        JOIN Results r2 ON c2.name = r2.car
        WHERE c2.class = cs.class
    ) AS total_races_in_class
FROM CarStats cs
JOIN ClassLowCount clc ON cs.class = clc.class
JOIN MaxClass mc ON clc.low_car_count = mc.max_count
ORDER BY clc.low_car_count DESC;