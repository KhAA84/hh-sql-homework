SELECT v.vacancy_id, v.position_name
FROM vacancy v
        INNER JOIN response r on v.vacancy_id = r.vacancy_id
WHERE DATE(r.creation_time) - DATE(v.creation_time) <= 7
GROUP BY v.vacancy_id, v.position_name
HAVING count(r.vacancy_id) > 5
ORDER BY v.vacancy_id