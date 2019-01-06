from __future__ import print_function

import requests

def load_urls():
    global MANAGER_URL
    global ENGINE_URL
    global AUTH_TUPLE

    # localhost
    # AUTH_TUPLE = ('@wsadmin', 'WSdemo01')
    # MANAGER_URL = 'http://lh.wordstream.com:8000'
    # ENGINE_URL = 'http://lh.wordstream.com:8080'

    # perf four
    AUTH_TUPLE = ('@t.brown', 'a8dNGUWKFK')
    MANAGER_URL = 'http://172.31.13.209'
    ENGINE_URL = 'http://172.31.12.71'
load_urls()

GET_PROFILES_ENDPOINT = '{engine_url}/admin/get_profiles?rows=1500&page=3'
PROFILE_LOGIN_ENDPOINT = '{engine_url}/admin/product_login/{profile_name}'
GET_CAMPAIGNS_ENDPOINT = '{manager_url}/services/v1/adwords/campaigns_light/'
PRODUCT_PARTITION_PERFORMANCE_ENDPOINT = (
    '{manager_url}/services/v1/adwords/campaigns/{campaign_id}/ad_groups/product_partitions_performance'
    '?startDate=20171201&endDate=20181209&sortBy=statsClicks&order=DESC&status=ALL_BUT_REMOVED&ppFilterBy=&limit=200&offset=0'
)

def main():
    session = requests.Session()
    session.auth = ('@t.brown', 'a8dNGUWKFK')
    try:
        profile_response = session.get(GET_PROFILES_ENDPOINT.format(engine_url=ENGINE_URL)).json()
    except Exception:
        print('Error: ', session.get(GET_PROFILES_ENDPOINT.format(engine_url=ENGINE_URL)))
        raise
    profile_names = [p['cell'][0] for p in profile_response['rows']]
    print('found {} profiles'.format(len(profile_names)))
    for profile in profile_names:
        print('processing profile', profile)
        login_response = session.get(PROFILE_LOGIN_ENDPOINT.format(profile_name=profile, engine_url=ENGINE_URL))
        campaigns_response = session.get(GET_CAMPAIGNS_ENDPOINT.format(manager_url=MANAGER_URL))
        if campaigns_response.status_code == 404:
            print(' no adwords campaigns found')
            continue
        campaigns_json = campaigns_response.json()

        campaign_ids = (c['id'] for c in campaigns_json['data'] if c['campaignType'] == 'SHOPPING')
        for campaign_id in campaign_ids:
            print(' getting campaign id', campaign_id)
            pp_response = session.get(PRODUCT_PARTITION_PERFORMANCE_ENDPOINT.format(
                campaign_id=campaign_id, manager_url=MANAGER_URL))
            pp_response.raise_for_status()

if __name__ == '__main__':
    main()
