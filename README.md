Docker ESN Elasticseach Container
=================================

Elasticsearch docker container for the ESN with preconfigured plugins and theirs automatic configuration.



| Environment variable         | Default value                                                                                                |
|------------------------------|--------------------------------------------------|
|ES_USERS_INDEX                |users.idx
|ES_USERS_TYPE                 |users
|ES_COMMUNITIES_INDEX          |communities.idx
|ES_COMMUNITIES_TYPE           |communities
|ES_CONTACTS_INDEX             |contacts.idx
|ES_CONTACTS_TYPE              |contacts
|MONGO_DB                      |rse
|MONGO_USERS_COLLECTION        |users
|MONGO_COMMUNITIES_COLLECTION  |communities


Build
-----

```
docker build -t linagora/esn-elasticsearch .
```

Run
---

```
docker run -p 9200:9200 -p 9300:9300 \
           -e ES_USERS_INDEX=users.idx \
           -e ES_USERS_TYPE=users \
           -e ES_COMMUNITIES_INDEX=communities.idx \
           -e ES_COMMUNITIES_TYPE=communities \
           -e ES_CONTACTS_INDEX=contacts.idx \
           -e ES_CONTACTS_TYPE=contacts \
           -e MONGO_DB=rse \
           -e MONGO_USERS_COLLECTION=users \
           -e MONGO_COMMUNITIES_COLLECTION=communities \
           linagora/esn-elasticsearch
```