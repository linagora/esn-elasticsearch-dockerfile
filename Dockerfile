#
# docker build -t linagora/esn-elasticsearch .
#
# Docker container with configured elasticsearch for ESN
#

FROM java:7-jre

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ELASTICSEARCH_VERSION 1.3.5
ENV ES_RIVER_VERSION 2.0.2
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update \
	&& apt-get install -y elasticsearch=$ELASTICSEARCH_VERSION git \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt/openpaas
RUN git clone https://ci.open-paas.org/stash/scm/or/esn-elasticsearch-configuration.git config
RUN git clone https://github.com/vishnubob/wait-for-it.git wait-for-it

ENV PATH /usr/share/elasticsearch/bin:$PATH
COPY config /usr/share/elasticsearch/config

VOLUME /usr/share/elasticsearch/data

# Install required ES Plugins
RUN plugin --install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/$ES_RIVER_VERSION

COPY ./docker-entrypoint.sh /
COPY ./scripts/start.sh /usr/bin/start.sh
COPY ./scripts/init-openpaas.sh /usr/bin/init-openpaas.sh
RUN chmod +x /usr/bin/init-openpaas.sh
COPY ./scripts/init-rivers.sh /usr/bin/init-rivers.sh
RUN cp /opt/openpaas/wait-for-it/wait-for-it.sh /usr/bin/wait-for-it.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["sh", "/usr/bin/start.sh"]
