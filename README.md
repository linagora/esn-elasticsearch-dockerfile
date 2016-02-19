# Docker ESN Elasticsearch Container

[![Build Status](https://travis-ci.org/linagora/esn-elasticsearch-dockerfile.svg?branch=master)](https://travis-ci.org/linagora/esn-elasticsearch-dockerfile)

Elasticsearch Docker container for OpenPaaS ESN with preconfigured plugins and indexes.

## List of environment variables

| Environment variable         | Default value                                                                                                |
|------------------------------|--------------------------------------------------|
|ES_USERS_INDEX                |users.idx
|ES_USERS_TYPE                 |users
|ES_COMMUNITIES_INDEX          |communities.idx
|ES_COMMUNITIES_TYPE           |communities
|ES_CONTACTS_INDEX             |contacts.idx
|ES_CONTACTS_TYPE              |contacts
|MONGO_HOST                    |localhost
|MONGO_PORT                    |27017
|MONGO_DB                      |esn
|MONGO_USERS_COLLECTION        |users
|MONGO_COMMUNITIES_COLLECTION  |communities


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
docker run -p 9200:9200 -p 9300:9300 \
           -e ES_USERS_INDEX=users.idx \
           -e ES_USERS_TYPE=users \
           -e ES_COMMUNITIES_INDEX=communities.idx \
           -e ES_COMMUNITIES_TYPE=communities \
           -e ES_CONTACTS_INDEX=contacts.idx \
           -e ES_CONTACTS_TYPE=contacts \
           -e MONGO_HOST=localhost
           -e MONGO_PORT=27017
           -e MONGO_DB=esn \
           -e MONGO_USERS_COLLECTION=users \
           -e MONGO_COMMUNITIES_COLLECTION=communities \
           linagora/esn-elasticsearch
```

**When used in the context of a compose file, the `MONGO_HOST` and `MONGO_PORT` are skipped**
