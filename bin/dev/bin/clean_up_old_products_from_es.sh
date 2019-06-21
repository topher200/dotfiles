#!/bin/bash

ES_HOST_ADDRESS=localhost:9200

set -x

curl \
    -X GET \
    -H "Content-Type: application/json" \
    "$ES_HOST_ADDRESS/mc-product/_search" \
    -d '
        {
            "query": {
                "range": {
                    "version.keyword": {
                        "lt": "2019-06-06"
                    }
                }
            }
        }
    '


lakers
houston
denver
jazz
okc
portland
