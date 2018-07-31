#! /usr/bin/python

"""
Posts a Bird message to slack

Author: t.brown@wordstream.com
"""


from __future__ import print_function

import urllib2
import json
import logging

HOOK_URL = "https://hooks.slack.com/services/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"

logger = logging.getLogger()
logger.setLevel(logging.INFO)


slack_message = {
    'text': 'Your shameful actions have summoned the FLIGHTLESS BIRD OF SHAME!',
    'channel': '#engineering',
    "username": "BIRD OF SHAME",
    "icon_emoji": ":party_parrot_sad:"
}

if __name__ == '__main__':
    req = urllib2.Request(HOOK_URL)
    req.add_header('Content-Type', 'application/json')
    urllib2.urlopen(req, json.dumps(slack_message))
    print('sent message')
