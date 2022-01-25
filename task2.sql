--Заполняем всопомогательные таблицы:
--1. area 6 записей
INSERT INTO area (area_name)
VALUES
    ('Москва'),
    ('Московская область'),
    ('Ленинградская область'),
    ('Ростовская область'),
    ('Краснодарский край'),
    ('Магаданская область');

--2. experience 5 записей
INSERT INTO experience (experience_name)
VALUES
    ('Не имеет значения'),
    ('Нет опыта'),
    ('От 1 года до 3 лет'),
    ('От 3 до 6 лет'),
    ('Более 6 лет');

--3. employment_type 5 записей
INSERT INTO employment_type (employment_type_name)
VALUES
    ('Полная занятость'),
    ('Частичная занятость'),
    ('Проектная работа'),
    ('Волонтерство'),
    ('Стажировка');

--4. working_schedule 5 записей
INSERT INTO working_schedule (working_schedule_name)
VALUES
    ('Полный день'),
    ('Сменный график'),
    ('Гибкий график'),
    ('Удаленная работа'),
    ('Вахтовый метод');

--Заполняем основные таблицы:
--5. specialization 100 записей
INSERT INTO specialization (specialization_name)
    SELECT 'Специальность_'|| item
FROM generate_series(1, 100) AS item;

--6. vacancy 10 000 записей
INSERT INTO vacancy (employer_id, position_name, specialization_id, compensation_from,
                     compensation_to, compensation_gross, employment_type_id,
                     working_schedule_id, working_experience, creation_time, area_id)
SELECT (random() * 299)::INTEGER + 1,
    'Должность_' || md5(random()::TEXT),
    (random() * (SELECT count(specialization_id) - 1 from specialization))::INTEGER + 1,
    20000 + (random() * 30)::INTEGER * 1000,
    50000 + (random() * 50)::INTEGER * 1000,
    (round(random())::INTEGER)::BOOLEAN,
    (random() * (SELECT count(employment_type_id) - 1 FROM employment_type))::INTEGER + 1,
    (random() * (SELECT count(working_schedule_id) - 1 FROM working_schedule))::INTEGER + 1,
    (random() * (SELECT count(experience_id) - 1 FROM experience))::INTEGER + 1,
    timestamp '2020-01-01' + INTERVAL '1 day' * round(random() * 730),
    (random() * (SELECT count(area_id) - 1 FROM area))::INTEGER + 1
FROM generate_series(1, 10000);

--7. cv 100 000 записей
INSERT INTO cv (cv_title, candidate_id, area_id, employment_type_id,
                     working_schedule_id, specialization_id, salary, creation_time)
SELECT 'Резюме_' || md5(random()::TEXT),
    (random() * 40000)::INTEGER,
    (random() * (SELECT count(area_id) - 1 FROM area))::INTEGER + 1,
    (random() * (SELECT count(employment_type_id) - 1 FROM employment_type))::INTEGER + 1,
    (random() * (SELECT count(working_schedule_id) - 1 FROM working_schedule))::INTEGER + 1,
    (random() * (SELECT count(specialization_id) - 1 FROM specialization))::INTEGER + 1,
    150000 + (random() * 150)::INTEGER * 1000,
    timestamp '2018-01-01' + INTERVAL '1 day' * round(random() * 730)
FROM generate_series(1, 100000);

--8. cv_specialization от 100 000 до 200 000 записей
-- способ как сделать запись от 1 до 2 записей с specialization_id для каждого cv_id (который при этом смог разобрать и понять)
-- нашёл тут: https://question-it.com/questions/2044874/postgresql-kak-sgenerirovat-sluchajnoe-kolichestvo-strok-poddelnyh-dannyh-s-ogranichenijami-vneshnego-kljucha
-- в запросе есть щепотка магии, чтобы обмануть оптимизатор
INSERT INTO  cv_specialization (cv_id, specialization_id)
SELECT cvs.cv_id, specializations.specialization_id
FROM cv AS cvs
CROSS JOIN LATERAL (SELECT specialization_id, cvs.cv_id FROM specialization ORDER BY random() LIMIT (1 + round(random()))) AS specializations;

--9.response 500 000 записей
INSERT INTO response (cv_id, vacancy_id, cover_letter, creation_time)
SELECT (random() * (SELECT count(cv_id) - 1 FROM cv))::INTEGER + 1,
    (random() * (SELECT count(vacancy_id) - 1 FROM vacancy))::INTEGER + 1,
    'Добрый день! Я хотел бы работать в вашей компании и отлично вам подхожу, потому что ' || md5(random()::text),
     timestamp '2022-01-02'
FROM generate_series(1, 500000);

UPDATE response
SET creation_time = (SELECT creation_time FROM vacancy WHERE response.vacancy_id = vacancy.vacancy_id) + INTERVAL '1 day' * round(random() * 50)
WHERE TRUE;








