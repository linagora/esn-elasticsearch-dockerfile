#
# docker build -t linagora/esn-elasticsearch .
#
# Docker container with configured elasticsearch for ESN
#

FROM elasticsearch:2.2.1

RUN apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/openpaas
RUN git clone https://ci.open-paas.org/stash/scm/or/esn-elasticsearch-configuration.git config
RUN git clone https://github.com/vishnubob/wait-for-it.git wait-for-it

COPY config /usr/share/elasticsearch/config

COPY ./docker-entrypoint.sh /
COPY ./scripts/start.sh /usr/bin/start.sh
COPY ./scripts/init-openpaas.sh /usr/bin/init-openpaas.sh
RUN chmod +x /usr/bin/init-openpaas.sh
RUN cp /opt/openpaas/wait-for-it/wait-for-it.sh /usr/bin/wait-for-it.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
USER elasticsearch

CMD ["sh", "/usr/bin/start.sh"]
