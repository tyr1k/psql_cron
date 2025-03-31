ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION}

ARG PCRON
ENV PCRON ${PCRON}

LABEL maintainer="emb_devops <artur.kashfullin@myoffice.team>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-${PCRON}-cron && \
    rm -rf /var/lib/apt/lists/*

COPY setup_analyze_vacuum.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/setup_analyze_vacuum.sh && \
    echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample

