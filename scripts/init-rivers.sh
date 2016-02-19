#!/bin/bash

# elasticsearch settings
es_host="localhost"
es_port="9200"
es_users_index="users.idx"
es_users_type="users"
es_communities_index="communities.idx"
es_communities_type="communities"
es_contacts_index="contacts.idx"
es_contacts_type="contacts"
[ -z "$ES_USERS_INDEX" ]        || es_index="$ES_USERS_INDEX"
[ -z "$ES_USERS_TYPE" ]         || es_index="$ES_USERS_TYPE"
[ -z "$ES_COMMUNITIES_INDEX" ]  || es_index="$ES_COMMUNITIES_INDEX"
[ -z "$ES_COMMUNITIES_TYPE" ]   || es_index="$ES_COMMUNITIES_TYPE"
[ -z "$ES_CONTACTS_INDEX" ]     || es_index="$ES_CONTACTS_INDEX"
[ -z "$ES_CONTACTS_TYPE" ]      || es_index="$ES_CONTACTS_TYPE"

# MongoDB settings
mongo_host="localhost"
mongo_port="27017"
mongo_db="esn"
mongo_users_collection="users"
mongo_communities_collection="communities"

# If use in standalone
[ -z "$MONGO_HOST" ] || mongo_host="$MONGO_HOST"
[ -z "$MONGO_PORT" ] || mongo_port="$MONGO_PORT"

# If use in a compose context
[ -z "$ESN_MONGO_PORT_27017_TCP_ADDR" ] || mongo_host="$ESN_MONGO_PORT_27017_TCP_ADDR"
[ -z "$ESN_MONGO_PORT_27017_TCP_PORT" ] || mongo_port="$ESN_MONGO_PORT_27017_TCP_PORT"

[ -z "$MONGO_DB" ]                      || mongo_db="$MONGO_DB"
[ -z "$MONGO_USERS_COLLECTION" ]        || mongo_users_collection="$MONGO_USERS_COLLECTION"
[ -z "$MONGO_COMMUNITIES_COLLECTION" ]  || mongo_communities_collection="$MONGO_COMMUNITIES_COLLECTION"

echo -e "Configuring ES River 1/2"
curl -s -XPUT "${es_host}:${es_port}/_river/${es_users_type}/_meta" -d "
{
  \"type\": \"mongodb\",
  \"mongodb\": {
    \"servers\": [
      { \"host\": \"${mongo_host}\", \"port\": ${mongo_port} }
    ],
    \"options\": { \"secondary_read_preference\": true },
    \"db\": \"${MONGO_DB}\",
    \"collection\": \"${mongo_users_collection}\"
  },
  \"index\": {
    \"name\": \"${es_users_index}\",
    \"type\": \"${es_users_type}\"
  }
}"

echo -e "Configuring ES River 2/2"
curl -s -XPUT "http://${es_host}:${es_port}/_river/${es_communities_type}/_meta" -d "
{
  \"type\": \"mongodb\",
  \"mongodb\": {
    \"servers\": [
      { \"host\": \"${mongo_host}\", \"port\": ${mongo_port} }
    ],
    \"options\": { \"secondary_read_preference\": true },
    \"db\": \"${mongo_db}\",
    \"collection\": \"${mongo_communities_collection}\"
  },
  \"index\": {
    \"name\": \"${es_communities_index}\",
    \"type\": \"${es_communities_type}\"
  }
}"
