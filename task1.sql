-- Таблица для хранения регионов
-- В оригинале там, кажется, какая-то сложная многоуровневая структура вероятно реализованная не одной таблицей,
-- для простоты делаю одну таблицу с иерархией
CREATE TABLE area (
    area_id SERIAL PRIMARY KEY,
    area_name TEXT NOT NULL
);

-- Таблица для Специализаций (1-ая из основных по заданию)
CREATE TABLE specialization (
    specialization_id SERIAL PRIMARY KEY,
    specialization_name TEXT NOT NULL
);

-- Таблица experience для хранения опыта работы
-- ('Не имеет значения', 'Нет опыта', 'От 1 года до 3 лет', 'От 3 до 6 лет', 'Более 6 лет')
CREATE TABLE experience (
    experience_id SERIAL PRIMARY KEY,
    experience_name TEXT NOT NULL
);

-- Таблица employment_type для хранения типов занятости
CREATE TABLE employment_type (
    employment_type_id SERIAL PRIMARY KEY,
    employment_type_name TEXT NOT NULL
);

-- Таблица working_schedule для хранения видов графиков работы
CREATE TABLE working_schedule (
    working_schedule_id SERIAL PRIMARY KEY,
    working_schedule_name TEXT NOT NULL
);

-- Таблица vacancy для Вакансий (2-ая из основных по заданию), поле employer_id подразумевает, что где-то
-- там в сторонке у нас есть таблица для работодателей
CREATE TABLE vacancy (
    vacancy_id SERIAL PRIMARY KEY,
    employer_id INTEGER NOT NULL,
    position_name TEXT NOT NULL,
    specialization_id INTEGER NOT NULL,
    compensation_from INTEGER,
    compensation_to INTEGER,
    compensation_gross BOOLEAN,
    employment_type_id INTEGER NOT NULL,
    working_schedule_id INTEGER NOT NULL,
    working_experience INTEGER,
    creation_time TIMESTAMP NOT NULL,
    area_id INTEGER NOT NULL,
    FOREIGN KEY (specialization_id) REFERENCES specialization (specialization_id),
    FOREIGN KEY (area_id) REFERENCES area (area_id),
    FOREIGN KEY (employment_type_id) REFERENCES employment_type (employment_type_id),
    FOREIGN KEY (working_schedule_id) REFERENCES working_schedule (working_schedule_id),
    FOREIGN KEY (working_experience) REFERENCES  experience (experience_id)
);

-- Таблица cv для резюме, поле candidate_id подразумевает, что где-то
-- там в сторонке у нас есть таблица для соискателей
CREATE TABLE cv (
    cv_id SERIAL PRIMARY KEY,
    cv_title TEXT NOT NULL,
    candidate_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    employment_type_id INTEGER NOT NULL,
    working_schedule_id INTEGER NOT NULL,
    specialization_id INTEGER NOT NULL,
    salary INTEGER,
    creation_time TIMESTAMP NOT NULL,
    FOREIGN KEY (area_id) REFERENCES area (area_id),
    FOREIGN KEY (employment_type_id) REFERENCES employment_type (employment_type_id),
    FOREIGN KEY (working_schedule_id) REFERENCES working_schedule (working_schedule_id)
);

-- Для резюме соответствие специализаций идёт 1->n
CREATE TABLE cv_specialization (
    cv_specialization_id SERIAL PRIMARY KEY,
    cv_id INTEGER NOT NULL,
    specialization_id INTEGER NOT NULL,
    FOREIGN KEY (cv_id) REFERENCES cv (cv_id),
    FOREIGN KEY (specialization_id) REFERENCES specialization (specialization_id)
);

-- Таблица response для откликов на вакансии
-- Предполагаю что "Я хочу здесь работать является другой сущность нежели отклик, поэтому
-- vacancy_id тоже NOT NULL
CREATE TABLE response (
    response_id SERIAL PRIMARY KEY,
    cv_id INTEGER NOT NULL,
    vacancy_id INTEGER NOT NULL,
    cover_letter TEXT,
    creation_time TIMESTAMP NOT NULL,
    FOREIGN KEY (cv_id) REFERENCES cv (cv_id),
    FOREIGN KEY (vacancy_id) REFERENCES vacancy (vacancy_id)
);



