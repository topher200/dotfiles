curl -H 'Session-Token: QMrX3GBdKTZX4en0bqguIGSy' \
     'http://lh.wordstream.com:8080/services/v1/adwords/performance/campaigns/adgroups/negative_keywords?start_date=2014-05-01&end_date=2016-05-31&offset=0&limit=8&order_by=DESC&negative_filter=ALL' \
    | python ~/dev/bin/unpickler.py

curl -H 'Session-Token: QMrX3GBdKTZX4en0bqguIGSy' \
     'http://lh.wordstream.com:8080/services/v1/adwords/performance/campaigns/adgroups/negative_keywords?start_date=2014-05-01&end_date=2016-05-31&offset=0&limit=8&order_by=DESC&negative_filter=ALL_BUT_REMOVED' \
    | python ~/dev/bin/unpickler.py

curl -H 'Session-Token: QMrX3GBdKTZX4en0bqguIGSy' \
     'http://lh.wordstream.com:8080/services/v1/adwords/performance/campaigns/1/adgroups/1/negative_keywords?sort_fields=campaign_name,start_date=2014-05-01&end_date=2016-05-31&offset=0&limit=8&order_by=DESC&negative_filter=CAMPAIGN' \
    | python ~/dev/bin/unpickler.py

curl -H 'Session-Token: QMrX3GBdKTZX4en0bqguIGSy' \
     'http://lh.wordstream.com:8080/services/v1/adwords/performance/campaigns/1/adgroups/1/negative_keywords?sort_fields=campaign_name,id&offset=0&limit=8&order_by=DESC&negative_filter=ADGROUP' \
    | python ~/dev/bin/unpickler.py
