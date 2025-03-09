
## Цель работы
*Получение практических навыков работы с промышленными СУБД, проектирование БД (концептуальное, логическое, физическое), создание хранимых процедур, представлений, триггеров, индексов.*
## Инструменты
*PostgreSQL, DBeaver, Gitlab, Draw.io*
## Описание проекта
*Проект базы данных для сети клиник. В состав сети входит несколько клиник с разными отделениями. Для каждого пациента формируется запись на приём к врачу, а затем вносятся данные об осмотре, выписанных лекарствах и анализах.*
## Сущности и их назначения в проектной БД
**Clinics (Клиники сети)** - это сущность, в которой записана основная информация о конкретном филиале в рамках сети частных клиник.

|                                                                   Clinics (Клиники сети) |                                 |              |             |
| ---------------------------------------------------------------------------------------- | ------------------------------- | ------------ | ----------- |
| Название                                                                                 | Описание                        | Тип данных   | Ограничения |
| clinic_id                                                                                | ID клиники                      | SERIAL       | PK          |
| address                                                                                  | Адрес клиники                   | VARCHAR(200) | NOT NULL    |
| rating_on_yandex_maps                                                                    | Оценка клиники на Яндекс.картах | FLOAT        |             |
| year_of_opening                                                                          | Год открытия клиники            | INTEGER      |             |

**Departments (Отделения)** - сущность, в которой записаны отделения клиники, специализирующиеся на определённых медицинских задачах. 

|                                                                   Departments (Отделения) |                                           |              |             |
| ----------------------------------------------------------------------------------------- | ----------------------------------------- | ------------ | ----------- |
| Название                                                                                  | Описание                                  | Тип данных   | Ограничения |
| department_id                                                                             | ID отделения                              | SERIAL       | PK          |
| clinic_id                                                                                 | ID клиники, в которой находится отделение | INTEGER      | FK          |
| department_name                                                                           | Название отделения                        | VARCHAR(50)  | NOT NULL    |
| head_of_department                                                                        | ФИО начальника отделения                  | VARCHAR(100) |             |

**Doctors (Врачи)** - сущность, где собрана информация о врачах клиники, причём версионируется по SCD2. Например, изменение информации о статусе отпуска, после его завершения сохранится в новую запись с актуальным временем.

|                                                                   Doctors (Врачи) |                                    |              |             |
| --------------------------------------------------------------------------------- | ---------------------------------- | ------------ | ----------- |
| Название                                                                          | Описание                           | Тип данных   | Ограничения |
| doctor_id                                                                         | ID врача                           | SERIAL       | PK          |
| department_id                                                                     | ID отделения, где работает врач    | INTEGER      | FK          |
| doctor_name                                                                       | Имя                                | VARCHAR(50)  | NOT NULL    |
| doctor_patronymic                                                                 | Отчество                           | VARCHAR(50)  | NOT NULL    |
| doctor_surname                                                                    | Фамилия                            | VARCHAR(50)  | NOT NULL    |
| specialization                                                                    | Специализация                      | VARCHAR(50)  | NOT NULL    |
| alma_mater                                                                        | Медицинский университет            | VARCHAR(100) |             |
| phone_number                                                                      | Рабочий номер телефона             | VARCHAR(20)  |             |
| vacation_status                                                                   | Статус отпуска                     | BOOL         |             |
| valid_from                                                                        | Дата начала актуальности записи    | DATE         |             |
| valid_to                                                                          | Дата окончания актуальности записи | DATE         |             |

**Patients (Пациенты)** - сущность, в которой хранится информация обо всех пациентах, зарегистрированных в сети. Она  так же версионируется по SCD2.

|                                                                   Patients (Пациенты) |                                    |             |             |
| ------------------------------------------------------------------------------------- | ---------------------------------- | ----------- | ----------- |
| Название                                                                              | Описание                           | Тип данных  | Ограничения |
| patients_id                                                                           | ID пациента                        | SERIAL      | PK          |
| patient_name                                                                          | Имя                                | VARCHAR(50) | NOT NULL    |
| patient_patronymic                                                                    | Отчество                           | VARCHAR(50) | NOT NULL    |
| patient_surname                                                                       | Фамилия                            | VARCHAR(50) | NOT NULL    |
| date_of_birth                                                                         | Дата рождения                      | DATE        |             |
| valid_from                                                                            | Дата начала актуальности записи    | DATE        |             |
| valid_to                                                                              | Дата окончания актуальности записи | DATE        |             |

**Appointment (Запись на приём)** - главная сущность, через которую происходит запись пациентов на приём к конкретному врачу. 

|                                                                   Appointment (Запись на приём) |                     |            |             |
| ----------------------------------------------------------------------------------------------- | ------------------- | ---------- | ----------- |
| Название                                                                                        | Описание            | Тип данных | Ограничения |
| appointment_id                                                                                  | ID приёма           | SERIAL     | PK          |
| doctor_id                                                                                       | ID врача            | INTEGER    | FK          |
| patients_id                                                                                     | ID пациента         | INTEGER    | FK          |
| appointment_time                                                                                | Дата и время приёма | TIMESTAMP  | NOT NULL    |

**Analysis (Направление на анализы)** - сущность, в которой хранится направление на анализы после конкретного приёма у врача.

|                                                                   Analysis (Направление на анализы) |                      |             |             |
| --------------------------------------------------------------------------------------------------- | -------------------- | ----------- | ----------- |
| Название                                                                                            | Описание             | Тип данных  | Ограничения |
| analysis_id                                                                                         | ID анализа           | SERIAL      | PK          |
| appointment_id                                                                                      | ID приёма            | INTEGER     | FK          |
| sample_type                                                                                         | Тип забора образца   | VARCHAR(50) |             |
| target_molecule                                                                                     | Молекула для анализа | VARCHAR(50) | NOT NULL    |
| analysis_method                                                                                     | Метод анализа        | VARCHAR(50) |             |

**Prescription (Рецепт на лекарства)** - сущность, в которой хранятся лекарства, прописанные после конкретного приёма у врача.

|                                                                   Prescription (Рецепт на лекарства) |                        |             |             |
| ---------------------------------------------------------------------------------------------------- | ---------------------- | ----------- | ----------- |
| Название                                                                                             | Описание               | Тип данных  | Ограничения |
| prescription_id                                                                                      | ID рецепта             | SERIAL      | PK          |
| appointment_id                                                                                       | ID приёма              | INTEGER     | FK          |
| drug_name                                                                                            | Название лекарства     | VARCHAR(50) | NOT NULL    |
| dose                                                                                                 | Дозировка, план приёма | VARCHAR(50) |             |
| duration                                                                                             | Длительность приёма    | INTERVAL    |             |

**Clinical Note (Медицинский осмотр)** - сущность, в которой врач оставляет информацию о приёме, включая симптомы и поставленный диагноз.

|                                                                   Clinical Note (Медицинский осмотр) |                      |              |             |
| ---------------------------------------------------------------------------------------------------- | -------------------- | ------------ | ----------- |
| Название                                                                                             | Описание             | Тип данных   | Ограничения |
| clinical_note_id                                                                                     | ID записи об осмотре | SERIAL       | PK          |
| appointment_id                                                                                       | ID приёма            | INTEGER      | FK          |
| symptoms                                                                                             | Симптомы             | VARCHAR(200) |             |
| diagnosis                                                                                            | Диагноз              | VARCHAR(200) | NOT NULL    |
