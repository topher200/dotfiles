# requires `pip install es2csv`, which requires python 2.7

es2csv \
    --output-file products_data_dump_2019-08-08.csv \
    --url https://vpc-aws4-perftest-four-1305-es-5oy2l4wk4yvffjy23l7kw5rdle.us-east-1.es.amazonaws.com \
    --index-prefixes mc-product \
    --max 0 \
    --query '*'
