## PostgreSQL с pg_cron и автоматическим VACUUM/ANALYZE

Этот репозиторий содержит Dockerfile для создания образа PostgreSQL с установленным расширением pg_cron. Также в образ включён скрипт, который автоматически добавляет задания [VACUUM](https://postgrespro.ru/docs/postgresql/15/sql-vacuum) и [ANALYZE](https://postgrespro.ru/docs/po    stgresql/14/sql-analyze) в pg_cron.   

Для сборки образа можно использовать [любой доступный tag] из официального(https://hub.docker.com/_/postgres/tags) репозитория PostgreSQL.

#### Использоование

- [Использование](#использование)
- [Проверка](#проверка)

## Использование

1. Запустите контейнер:

    ```bash
    docker run -d -e POSTGRES_DB=<data_base_name> -e POSTGRES_PASSWORD=<data_base_pass>  postgres-cron-vacuum-analyze
    ```

2. Контейнер автоматически запустит PostgreSQL и выполнит скрипт `setup_analyze_vacuum.sh`, который настроит задачи VACUUM и ANALYZE для вашей базы данных.

## Проверка

1. Подключитесь к работающему контейнеру:

    ```bash
    docker exec -it <container_name> bash
    ```

2. Проверьте задачи VACUUM и ANALYZE:

    ```bash
    psql -U postgres -d <data_base_name> -c "SELECT * FROM cron.job;"
    ```
