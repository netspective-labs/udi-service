FROM postgres:15.4
ENV PG_MAJOR=15
ENV PGTAP_VERSION v1.1.0
ENV PGAUDIT_VERSION 1.7.0
ENV POSTGIS_MAJOR 3
ENV PLV8_VERSION=r3.2
RUN apt-get update
RUN apt-get install -y postgresql-15 postgresql-server-dev-15
# Install postgis
RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && apt-get install software-properties-common -y \
      && apt-get install git make -y \
      && apt-get install build-essential -y

# Install pgtap
RUN git clone https://github.com/theory/pgtap.git \
    && cd pgtap && git checkout tags/$PGTAP_VERSION \
    && make install

# Install plpython3
RUN apt-get update \
      && apt-get install -y postgresql-contrib postgresql-plpython3-$PG_MAJOR libpq-dev

# Install python3-pip
RUN apt install -y python3-pip

# Install PL/SH
RUN apt install -y postgresql-${PG_MAJOR}-plsh

# Install PL/PERL
RUN apt install -y postgresql-plperl-$PG_MAJOR


RUN apt-get update && \
    apt-get purge -y postgresql-16 && \
    apt-get autoremove -y

# Install pgAudit
#RUN pgAuditDependencies="postgresql-server-dev-$PG_MAJOR \
    #libssl-dev \
    #libkrb5-dev \
    #git-core \
    #wget" \
    #&& apt-get install -y --no-install-recommends ${pgAuditDependencies} \
    #&& cd /tmp \
    #&& git clone https://github.com/pgaudit/pgaudit.git \
    #&& cd pgaudit && git checkout checkout REL_15_STABLE \
    #&& make install USE_PGXS=1 PG_CONFIG=/usr/pgsql-15/bin/pg_config

# Install plv8
RUN apt-get update && apt-get install -y \
    postgresql-server-dev-${PG_MAJOR} \
    ca-certificates \
    curl \
    git-core \
    gpp \
    cpp \
    pkg-config \
    apt-transport-https \
    cmake \
    libc++-dev \
    libc++abi-dev \
    libc++1 \
    libtinfo5 \
    libc++abi1
RUN apt-get install wget
RUN apt-get install ninja-build
RUN git clone https://github.com/plv8/plv8.git /tmp/plv8
    #git checkout $PLV8_VERSION
RUN cd /tmp/plv8 && \
    make && \
    make install

# Install plpgsql_check
RUN apt-get update \
    && apt-get install -y gcc libicu-dev postgresql-server-dev-$PG_MAJOR \
    && cd /tmp \
    && git clone https://github.com/okbob/plpgsql_check.git \
    && cd plpgsql_check \
    && make \
    && make install

# Install pgsql-http
RUN apt-get install -y libcurl4-openssl-dev \
    && cd /tmp \
    && git clone https://github.com/pramsey/pgsql-http.git \
    && cd pgsql-http \
    && make clean \
    && make install


# Install pg_cron
RUN apt-get -y install postgresql-$PG_MAJOR-cron

RUN apt-get -y install libwww-perl
RUN apt-get -y install libjson-perl
RUN apt-get -y install libdatetime-perl python3-psycopg2 python3-psutil

RUN apt-get update && \
    apt-get purge -y postgresql-16 && \
    apt-get autoremove -y

# Install pg-semver
RUN cd /tmp && git clone https://github.com/theory/pg-semver.git \
    && cd pg-semver \
    && make \
    && make install

# Install is_jsonb_valid
RUN cd /tmp && git clone https://github.com/furstenheim/is_jsonb_valid.git \
    && cd is_jsonb_valid  \
    && make \
    && make install

# Install file_text_array_fdw
RUN cd /tmp && git clone https://github.com/adunstan/file_text_array_fdw.git \
    && cd file_text_array_fdw  \
    && git checkout REL_${PG_MAJOR}_STABLE \
    && make USE_PGXS=1 install


# Install pgvector
RUN cd /tmp && git clone https://github.com/ankane/pgvector.git \
    && cd pgvector \
    && make \
    && make install

# Install Python-modules
#RUN pip3 install --upgrade pip \
    #&& pip3 install pillow imagehash python-magic python-gitlab \
        #PyYAML python-keycloak 'requests>=2.26.0' 'urllib3>=1.26.6' \
        #PyGithub json2xml opentelemetry-api opentelemetry-sdk \
        #opentelemetry-launcher opentelemetry-exporter-otlp \
    #&& pip3 install --upgrade cython

# Install sqlite_fdw
RUN apt-get install -y libsqlite3-dev \
    && cd /tmp \
    && git clone https://github.com/pgspider/sqlite_fdw.git \
    && cd sqlite_fdw \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install

# Install tds_fdw
RUN apt-get install -y freetds-dev
RUN apt-get install -y  git gcc libc-dev make
RUN cd /tmp \
    && git clone https://github.com/tds-fdw/tds_fdw.git \
    && cd tds_fdw \
    && make \
    && make USE_PGXS=1 install

# Install pgjwt
RUN cd /tmp \
    && git clone https://github.com/michelp/pgjwt.git \
    && cd pgjwt \
    && make install

# Install  safeupdate
RUN apt-get install -y pgxnclient \
    && pgxn install safeupdate

#Install pg_tle
RUN apt-get update
RUN apt-get install flex libkrb5-dev -y
RUN cd /tmp
RUN git clone https://github.com/aws/pg_tle.git /tmp/pg_tle \
    && cd /tmp/pg_tle \
    && make \
    && make install

#Install pgml
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       postgresql-server-dev-15 \
    && rm -rf /var/lib/apt/lists/*
RUN cd /tmp
RUN git clone https://github.com/postgresml/postgresml.git /tmp/pgml \
     && cd /tmp/pgml \
RUN pip3 install -r pgml-extension/requirements.txt

#Install pggraphql
#RUN cd /tmp
#RUN git clone https://github.com/supabase/pg_graphql.git /tmp/pg-graphql \
    #&& cd /tmp/pg-graphql
#RUN make && make install


#Install pg_stat_kcache
RUN cd /tmp
RUN git clone https://github.com/powa-team/pg_stat_kcache.git /tmp/pg_stat_kcache \
    && cd /tmp/pg_stat_kcache \
    && make \
    && make install

#Install mysql_fdw
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       postgresql-server-dev-15 \
       mariadb-client \
       libmariadb-dev-compat \
    && rm -rf /var/lib/apt/lists/*
RUN cd /tmp
RUN git clone https://github.com/EnterpriseDB/mysql_fdw.git /tmp/mysql_fdw \
    && cd /tmp/mysql_fdw \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install

#Install pg_later
#RUN cd /tmp
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#RUN mkdir /var/lib/postgresql/.pgrx/
#RUN export PGRX_HOME=/var/lib/postgresql/.pgrx/
#RUN cargo install --locked cargo-pgrx --version 0.9.8
#RUN cargo pgrx install
#RUN git clone  https://github.com/tembo-io/pgmq.git  /tmp/pgmq
#RUN cd /tmp/pgmq \
    #&& make \
    #&& make install
#ENV PATH="/root/.cargo/bin:${PATH}"
#RUN git clone https://github.com/tembo-io/pg_later.git /tmp/pg_later \
    #&& cd /tmp/pg_later \
    #&& make \
    #&& make install

#Install pg_graphql
RUN cd /tmp
RUN git clone https://github.com/supabase/pg_graphql.git /tmp/pg_graphql
RUN cd /tmp/pg_graphql
RUN cargo pgrx install --release
# Cleanup
RUN rm -rf /tmp/ && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
