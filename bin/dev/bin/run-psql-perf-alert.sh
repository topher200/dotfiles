#!/bin/bash

psql postgresql://postgres:WS.password@aws3-perftest-three-1587-adwordsdb.cok8gwsmtznr.us-east-1.rds.amazonaws.com:5432/adwords \
     --quiet --no-psqlrc \
     --command "
COPY (
    SELECT a.alert_id,
           a.account_id,
           acc.profile_id,
           a.alert_type,
           kvc.name AS campaign_name,
           kvc.advertising_channel_type AS campaign_advertising_channel_type,
           kv.key,
           kv.value
    FROM alerts a
    LEFT JOIN
        (SELECT kv.alert_id,
                kv.value,
                c.id,
                c.name,
                c.advertising_channel_type
         FROM alerts_kv kv
         JOIN campaign c ON kv.value::INTEGER=c.id
         WHERE kv.key='campaign_id') kvc ON a.alert_id=kvc.alert_id
    JOIN alerts_kv kv ON a.alert_id=kv.alert_id
    JOIN account acc ON a.account_id = acc.id
    WHERE is_latest IS TRUE
        AND alert_type='DEVICE_BID_ADJUSTMENT_ALERT'
        AND kv.key!='campaign_id'
) TO STDOUT WITH CSV HEADER"
