SELECT vacancy_month AS vacancy_month,
       cv_month AS cv_month
FROM (
         SELECT to_char(creation_time, 'MONTH') AS vacancy_month,
                count(*) AS count
         FROM vacancy
         GROUP BY vacancy_month
         ORDER BY count DESC
         LIMIT 1
     ) AS v
         INNER JOIN (
    SELECT to_char(creation_time, 'MONTH') AS cv_month,
           count(*) AS count
    FROM cv
    GROUP BY cv_month
    ORDER BY count DESC
    LIMIT 1
) as c ON true;