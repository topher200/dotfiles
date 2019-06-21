# requires `pip install es2csv`

es2csv \
    --output-file new_products_data_dump.csv \
    --url https://vpc-aws1-perftest-one-1804-es-hywlozme3rdpytwa5zo2eidmdy.us-east-1.es.amazonaws.com \
    --index-prefixes mc-product \
    --max 0 \
    --query '*'
