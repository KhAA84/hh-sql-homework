
--Самый простой вариант запроса, не учитывающий вообще никаких дополнительных условий
SELECT
    ROUND(AVG(compensation_from), 2) AS average_compensation_from,
    ROUND(AVG(compensation_to), 2) AS average_compensation_to,
    ROUND(AVG((compensation_to + compensation_from) / 2), 2) AS average_from_to
FROM vacancy
GROUP BY area_id
ORDER BY area_id;

--а у нас есть gross
SELECT
    ROUND(AVG(compensation_from), 2) AS average_compensation_from,
    ROUND(AVG(compensation_to), 2) AS average_compensation_to,
    ROUND(AVG((compensation_to + compensation_from) / 2), 2) AS average_from_to
FROM (SELECT area_id,
        CASE
            WHEN compensation_gross IS TRUE
                THEN compensation_from * 0.87
            ELSE compensation_from
            END AS compensation_from,
        CASE
            WHEN compensation_gross IS TRUE
                THEN compensation_to * 0.87
            ELSE compensation_to
            END AS compensation_to
    FROM vacancy v) AS temp
GROUP BY area_id
ORDER BY area_id;