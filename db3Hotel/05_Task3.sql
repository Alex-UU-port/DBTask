WITH HotelCategory AS (
    -- Определяем категорию каждого отеля
    SELECT 
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS avg_price,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_type
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerHotelTypes AS (
    -- Определяем какие типы отелей посещал клиент
    SELECT 
        c.ID_customer,
        c.name,
        hc.hotel_type,
        hc.hotel_name
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN HotelCategory hc ON r.ID_hotel = hc.ID_hotel
),
CustomerPreference AS (
    -- Определяем предпочитаемый тип
    SELECT 
        ID_customer,
        name,
        CASE
            WHEN SUM(hotel_type = 'Дорогой') > 0 THEN 'Дорогой'
            WHEN SUM(hotel_type = 'Средний') > 0 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type
    FROM CustomerHotelTypes
    GROUP BY ID_customer, name
)
SELECT 
    cp.ID_customer,
    cp.name,
    cp.preferred_hotel_type,
    GROUP_CONCAT(DISTINCT cht.hotel_name ORDER BY cht.hotel_name SEPARATOR ', ') AS visited_hotels
FROM CustomerPreference cp
JOIN CustomerHotelTypes cht 
    ON cp.ID_customer = cht.ID_customer
GROUP BY cp.ID_customer, cp.name, cp.preferred_hotel_type
ORDER BY 
    FIELD(cp.preferred_hotel_type, 'Дешевый', 'Средний', 'Дорогой');