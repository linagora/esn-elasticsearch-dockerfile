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
mongo_db="rse"
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

echo -e "Analyzer configuration"
curl -s -i -XPUT "${es_host}:${es_port}/${es_users_index} " -d'
{
   "settings": {
      "analysis": {
         "filter": {
            "nGram_filter": {
               "type": "nGram",
               "min_gram": 1,
               "max_gram": 20,
               "token_chars": [
                  "letter",
                  "digit",
                  "punctuation",
                  "symbol"
               ]
            }
         },
         "analyzer": {
            "nGram_analyzer": {
               "type": "custom",
               "tokenizer": "whitespace",
               "filter": [
                  "lowercase",
                  "asciifolding",
                  "nGram_filter"
               ]
            },
            "whitespace_analyzer": {
               "type": "custom",
               "tokenizer": "whitespace",
               "filter": [
                  "lowercase",
                  "asciifolding"
               ]
            }
         }
      }
   },
   "mappings": {
      "users" : {
        "properties" : {
            "firstname" : {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer",
			   "fields": {
			   	"sort": {
			   	"type": "string",
			   	"index": "not_analyzed"
		   		}
	   		   }
            },
            "lastname" : {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
            },
            "accounts": {
               "type": "nested",
               "include_in_parent": true,
               "properties": {
                  "emails" : {
                     "type": "string",
                     "index_analyzer": "nGram_analyzer",
                     "search_analyzer": "whitespace_analyzer"
                  }
               }
            }
         }
      }
   }
}'

echo -e "Setting up contacts"
curl -s -i -XPUT "${es_host}:${es_port}/${es_contacts_index} " -d'
{
   "settings": {
      "analysis": {
         "filter": {
            "nGram_filter": {
               "type": "nGram",
               "min_gram": 1,
               "max_gram": 20,
               "token_chars": [
                  "letter",
                  "digit",
                  "punctuation",
                  "symbol"
               ]
            }
         },
         "analyzer": {
            "nGram_analyzer": {
               "type": "custom",
               "tokenizer": "whitespace",
               "filter": [
                  "lowercase",
                  "asciifolding",
                  "nGram_filter"
               ]
            },
            "whitespace_analyzer": {
               "type": "custom",
               "tokenizer": "whitespace",
               "filter": [
                  "lowercase",
                  "asciifolding"
               ]
            }
         }
      }
   },
   "mappings": {
      "contacts": {
        "properties" : {
          "fn" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer",
			      "fields": {
			   	    "sort": {
			   	      "type": "string",
			   	      "index": "not_analyzed"
		   		    }
	   		   }
         },
         "name": {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "firstName" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "lastName" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "emails" : {
           "properties": {
             "type": {"type": "string", "index": "no"},
             "value": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             }
           }
         },
         "tel" : {
           "properties": {
             "type": {"type": "string", "index": "no"},
             "value": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             }
           }
         },
         "org" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "job" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "urls" : {
           "properties": {
             "type": {"type": "string", "index": "no"},
             "value": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             }
           }
         },
         "tags" : {
           "properties": {
             "text": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             }
           }
         },
         "socialprofiles" : {
           "properties": {
             "type": {"type": "string", "index": "no"},
             "value": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             }
           }
         },
         "nickname" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "birthday" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "comments" : {
            "type": "string",
            "index_analyzer": "nGram_analyzer",
            "search_analyzer": "whitespace_analyzer"
         },
         "addresses" : {
           "properties": {
             "full": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             },
             "type": {"type": "string", "index": "no"},
             "street": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             },
             "city": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             },
             "zip": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             },
             "country": {
               "type": "string",
               "index_analyzer": "nGram_analyzer",
               "search_analyzer": "whitespace_analyzer"
             }
           }
         }
       }
     }
   }
}'

echo -e "Configuring River 1/2"
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

echo -e "Configuring River 2/2"
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
