CREATE TABLE doctor(
    doctor_id serial PRIMARY KEY NOT NULL,
    surname varchar(50) NOT NULL,
    firstname varchar(50) NOT NULL,
    patronymic varchar(20) NULL,
    dep_id int NOT NULL,
    spec_id int NOT NULL);

	CREATE TABLE spec(
    spec_id serial PRIMARY KEY NOT NULL, 
    name varchar(100) NOT NULL
);

CREATE TABLE deps(
    dep_id int PRIMARY KEY NOT NULL, 
    name varchar(100) NOT NULL

);
ALTER TABLE doctor ADD CONSTRAINT fk_doctor_spec FOREIGN KEY (spec_id) REFERENCES spec(spec_id);
ALTER TABLE doctor ADD CONSTRAINT fk_doctor_dept FOREIGN KEY (dep_id) REFERENCES deps(dep_id);
INSERT INTO spec VALUES 
    (1, 'Терапевт'),
    (3, 'Венеролог'),
    (55, 'Трихолог'),
    (2, 'Хирург'),
    (4, 'Педиатр'),
    (5, 'Кардиолог'),
    (6, 'Невролог'),
    (7, 'Онколог'),
    (8, 'ЛОР (Отоларинголог)'),
    (9, 'Офтальмолог'),
    (10, 'Эндокринолог'),
    (11, 'Дерматолог'),
    (12, 'Рентгенолог');

INSERT INTO deps VALUES 
    (1, 'Кардиологическое отделение'),
    (12, 'Пульмонологическое отделение'),
    (13, 'Гастроэнтерологическое отделение'),
    (4, 'Хирургическое отделение'),
    (5, 'Педиатрическое отделение'),
    (6, 'Неврологическое отделение'),
    (7, 'Онкологическое отделение'),
    (8, 'ЛОР-отделение'),
    (9, 'Эндокринологическое отделение'),
    (10, 'Дерматологическое отделение');
    
INSERT INTO doctor VALUES 
    (1, 'Федоров', 'Илья', 'Васильевич', 12, 1),
    (2, 'Мозгунова', 'Светлана', 'Яковлевна', 9, 11),
    (3, 'Крылова', 'Екатерина', 'Игоревна', 13, 55),
    (4, 'Фёдорова', 'Светлана', 'Фёдоровна', 12, 1),
    (5, 'Семенов', 'Андрей', 'Петрович', 4, 2),
    (6, 'Смирнова', 'Татьяна', 'Николаевна', 1, 10),
    (7, 'Иванов', 'Дмитрий', 'Олегович', 5, 4),
    (8, 'Новикова', 'Мария', 'Александровна', 6, 7),
    (9, 'Лебедева', 'Ольга', 'Евгеньевна', 7, 6),
    (10, 'Кузнецов', 'Юрий', 'Сергеевич', 8, 9),
    (11, 'Антонов', 'Глеб', 'Владимирович', 9, 12),
    (12, 'Соколова', 'Наталья', 'Алексеевна', 10, 11);

SELECT * FROM deps;
SELECT * FROM doctor;
select 
    doctor.surname Фамилия, 
    doctor.firstname Имя, 
    doctor.patronymic Отчество, 
    deps.name Отделение, 
    spec.name Специализация_доктора
from deps 
inner join (spec 
    inner join doctor 
    on spec.spec_id = doctor.spec_id) 
on deps.dep_id = doctor.dep_id;

CREATE TABLE appointment (
    therapy_id INT NOT NULL,
    drug_id INT NOT NULL,
    dose INT NOT NULL,
    PRIMARY KEY (therapy_id, drug_id)
);
CREATE TABLE diag (
    diag_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE drug (
    drug_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    compound TEXT NOT NULL,
    recomendations TEXT NOT NULL,
    drug_type_id INT NOT NULL
);
CREATE TABLE drug_type (
    drug_type_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE pacient (
    pacient_id SERIAL PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    age INT NOT NULL,
    sex VARCHAR(20) NOT NULL,
    address TEXT NOT NULL
);
CREATE TABLE therapy (
    therapy_id SERIAL PRIMARY KEY,
    diag_id INT NOT NULL,
    pacient_id INT NOT NULL,
    doctor_id INT NOT NULL
);
-- Соединение таблицы Лечение с таблицей Пациенты
ALTER TABLE therapy
ADD CONSTRAINT fk_therapy_pacient
FOREIGN KEY (pacient_id) REFERENCES pacient (pacient_id);

-- Соединение таблицы Лечение с таблицей Врачи
ALTER TABLE therapy
ADD CONSTRAINT fk_therapy_doctor
FOREIGN KEY (doctor_id) REFERENCES doctor (doctor_id);

-- Соединение таблицы Лечение с таблицей Диагнозы
ALTER TABLE therapy
ADD CONSTRAINT fk_therapy_diag
FOREIGN KEY (diag_id) REFERENCES diag (diag_id);

-- Соединение таблицы Препараты с таблицей Виды препаратов
ALTER TABLE drug
ADD CONSTRAINT fk_drug_type
FOREIGN KEY (drug_type_id) REFERENCES drug_type (drug_type_id);

-- Соединение таблицы Назначения с таблицей Лечение
ALTER TABLE appointment
ADD CONSTRAINT fk_appointment_therapy
FOREIGN KEY (therapy_id) REFERENCES therapy (therapy_id);

-- Соединение таблицы Назначения с таблицей Препараты
ALTER TABLE appointment
ADD CONSTRAINT fk_appointment_drug
FOREIGN KEY (drug_id) REFERENCES drug (drug_id);