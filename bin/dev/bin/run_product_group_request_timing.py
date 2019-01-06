from __future__ import print_function

import time

import requests

def load_urls():
    global MANAGER_URL
    global ENGINE_URL
    global AUTH_TUPLE

    # localhost
    AUTH_TUPLE = ('@wsadmin', 'WSdemo01')
    MANAGER_URL = 'http://lh.wordstream.com:8000'
    ENGINE_URL = 'http://lh.wordstream.com:8080'

    # perf four
    # AUTH_TUPLE = ('@t.brown', 'a8dNGUWKFK')
    # MANAGER_URL = 'http://172.31.13.209'
    # ENGINE_URL = 'http://172.31.12.71'
load_urls()

GET_PROFILES_ENDPOINT = '{engine_url}/admin/get_profiles?rows=1500&page=3'
PROFILE_LOGIN_ENDPOINT = '{engine_url}/admin/product_login/{profile_name}'
GET_CAMPAIGNS_ENDPOINT = '{manager_url}/services/v1/adwords/campaigns_light/'
PRODUCT_PARTITION_PERFORMANCE_ENDPOINT = (
    '{manager_url}/services/v1/adwords/campaigns/{campaign_id}'
    '/ad_groups/product_partitions_performance'
    '?startDate=20171201&endDate=20181209&sortBy=statsClicks&order=DESC'
    '&status=ALL_BUT_REMOVED&ppFilterBy=&limit=200&offset=0'
)
PROFILE_NAMES = [
    'best_accounts', # small
    'prod-mbcarr_segalco', # medium
    '2wheelnew', # large
]

def main():
    session = requests.Session()
    session.auth = AUTH_TUPLE
    min_times = {}
    for profile in PROFILE_NAMES:
        print('processing profile', profile)
        login_response = session.get(
            PROFILE_LOGIN_ENDPOINT.format(profile_name=profile, engine_url=ENGINE_URL))
        del login_response # not used
        campaigns_response = session.get(GET_CAMPAIGNS_ENDPOINT.format(manager_url=MANAGER_URL))
        if campaigns_response.status_code == 404:
            print(' no adwords campaigns found')
            continue
        try:
            campaigns_json = campaigns_response.json()
        except Exception:
            print ('error!', campaigns_response, campaigns_response.text)
            raise

        campaign_ids = (c['id'] for c in campaigns_json['data'] if c['campaignType'] == 'SHOPPING')
        for campaign_id in campaign_ids:
            for _ in range(5):
                url = PRODUCT_PARTITION_PERFORMANCE_ENDPOINT.format(
                    campaign_id=campaign_id, manager_url=MANAGER_URL)
                start_time = time.time()
                pp_response = session.get(url)
                call_time = time.time() - start_time
                print(' %.2fs to get product groups for campaign id %d' % (call_time, campaign_id))
                pp_response.raise_for_status()
                min_times[campaign_id] = min_times[campaign_id] \
                    if campaign_id in min_times and min_times[campaign_id] < call_time else call_time

    for k in sorted(min_times):
        print('min time for %04d: %.2fs' % (k, min_times[k]))

if __name__ == '__main__':
    main()
