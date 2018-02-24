from boto.connection import AWSAuthConnection

class ESConnection(AWSAuthConnection):

    def __init__(self, region, **kwargs):
        super(ESConnection, self).__init__(**kwargs)
        self._set_auth_region_name(region)
        self._set_auth_service_name("es")

    def _required_auth_capability(self):
        return ['hmac-v4']

if __name__ == "__main__":

    client = ESConnection(
            region='us-east-1',
            # endpoint = "s3.amazonaws.com",
            # host='vpc-stats-from-logs-5-5-negcbvqilnfy4da5p5pjf2oitm.us-east-1.es.amazonaws.com',
            host='vpc-stats-from-logs-6-0-xiffda5pw6howr5u6wxxwkkkby.us-east-1.es.amazonaws.com/',
            aws_access_key_id='AKIAJWPPYV52ENGD4MNQ',
            aws_secret_access_key='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',
        is_secure=False)

    print 'Registering Snapshot Repository'
    resp = client.make_request(method='POST',
            path='/_snapshot/stats-from-logs-backups',
            data='{"type": "s3","settings": { "bucket": "stats-from-logs","endpoint": "s3.amazonaws.com","role_arn": "arn:aws:iam::450035922800:role/stats-from-logs-migrator"}}',
            headers={'Content-Type': 'application/json'})
    body = resp.read()
