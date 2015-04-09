Docker ESN Elasticseach Container
=================================

Elasticsearch docker container for the ESN with preconfigured plugins.

Build
-----

```
docker build -t linagora/esn-elasticsearch
```

Run
---

```
docker run -p 9200:9200 -p 9300:9300 linagora/esn-elasticsearch
```
