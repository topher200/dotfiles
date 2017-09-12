#!/bin/bash

export WORKON_HOME=/Users/t.brown/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
workon wordstream

cd /Users/t.brown/dev/wsautomation/_Tools/ExecuteAutomation

# ./api_local.sh -s 'campaigns_performance_stats' -s 'keyword_id' -s 'bulk_update_adgroups'
# ./api_local.sh -s 'bulk_update_adgroups'
# ./api_local.sh -s 'bing_textads'
# ./api_local.sh -s 'campaigns_performance_stats'
# ./api_local.sh -s 'alerts'
# ./api_local.sh -s 'dynamic_search_ad'
# ./api_local.sh -s 'example_entities'
# ./api_local.sh -s 'user_profile_preferences'
# ./api_local.sh -s 'campaign_entities'
# ./api_local.sh -s 'goals'
./api_local.sh -s 'keyword_tool'
