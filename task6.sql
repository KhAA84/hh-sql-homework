
--гипотеза: соискатели ищут работу по специализации и гарантированной зарплате
--создаю для таблицы vacancy индекс по полям specialization_id и compensation_from
CREATE INDEX vacancy_specialization_compensation_index ON vacancy (specialization_id, compensation_from);

--гипотеза: соискатели могут искать работы в своём регионе по своей специализации
--создаю для таблицы vacancy индекс по полям specialization_id и area_id
CREATE INDEX vacancy_specialization_area_index ON vacancy (specialization_id, area_id);

--гипотеза: работодатели ищут резюме по специализации и региону
--создаю для таблицы cv индекс по полям specialization_id и area_id
CREATE INDEX cv_specialization_area_index ON cv (specialization_id, area_id);

--гипотеза: соискатели ищут свежие вакансии в своём регионе
--создаю индекс для таблицы vacancy по полям creation_time и area_id
CREATE INDEX vacancy_date_area_index ON vacancy (creation_time, area_id);
