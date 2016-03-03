# Docker ESN Elasticsearch Container

[![Build Status](https://travis-ci.org/linagora/esn-elasticsearch-dockerfile.svg?branch=master)](https://travis-ci.org/linagora/esn-elasticsearch-dockerfile)

Elasticsearch Docker container for OpenPaaS ESN with preconfigured plugins and indexes.

## Pull

```
docker pull linagora/esn-elasticsearch
```

## Build

```
git clone https://github.com/linagora/esn-elasticsearch-dockerfile.git
docker build -t linagora/esn-elasticsearch .
```

## Run

```
docker run -p 9200:9200 -p 9300:9300 linagora/esn-elasticsearch
```

### Environment variables

- ELASTICSEARCH_INIT_TIMEOUT: The timeout to wait to initialize elasticsearch indexes. The initialization script will be launched as soon as elasticsearch is reachable on its default port. Default value is 60 seconds.

```
docker run -p 9200:9200 -p 9300:9300 -e "ELASTICSEARCH_INIT_TIMEOUT=120" linagora/esn-elasticsearch
```
