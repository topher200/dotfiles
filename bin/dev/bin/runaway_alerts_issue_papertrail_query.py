"""
    Get all the profiles which have completed alerts for a specific run.

    # Usage
    ## Prerequisites
    - Requires python 3.7
    - Requires the papertrail-cli Ruby gem. Requires credentials for Papertrail to be set up.

    ## Before you can run this script...
    Download logs from papertrail into a file using a command like this:
        papertrail "wordstream.update.UpdateAlertsCommand: Finished updating profile" --json --min-time '2019-08-03' --max-time '2019-08-07' > pt.txt

    NOTE: You must use --min-time and --max-time, or papertrail-cli will save the JSON in an unsupported format.

    ## Running the script
        python runaway_alerts_issue_papertrail_query.py

    ## Tests
        python -m doctest runaway_alerts_issue_papertrail_query.py
"""


from typing import Dict
import collections
import dataclasses
import datetime
import json
import pprint
import re


JSON_FILE = 'pt.txt'
OUT_FILE = 'completed_profiles.txt'


@dataclasses.dataclass()
class Timings:
    time_completed: datetime.datetime = None
    num_total_profiles_in_run: int = 0


def main():
    raw_papertrail_json = {}
    raw_papertrail_json['events'] = []
    with open(JSON_FILE) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            papertrail_json = json.loads(line)
            raw_papertrail_json['events'].append(papertrail_json)

    cache = __parse_papertrail(raw_papertrail_json)

    with open(OUT_FILE, 'w') as f:
        for name, timings in cache.items():
            f.write('%s\n' % (name))


def __parse_papertrail(papertrail_json:dict) -> Dict[str, Timings]:
    cache = collections.defaultdict(Timings)
    for event in papertrail_json['events']:
        message = event['message']
        name = __parse_name(message)
        cache[name].time_completed = __parse_datetime_from_papertrail(event['generated_at'])
        cache[name].num_total_profiles_in_run = __parse_num_totals_in_run(message)
    return cache


def __parse_datetime_from_papertrail(generated_at:str) -> datetime.datetime:
    """
        >>> __parse_datetime_from_papertrail('2019-04-30T23:03:12-04:00')
        datetime.datetime(2019, 4, 30, 23, 3, 12, tzinfo=datetime.timezone(datetime.timedelta(days=-1, seconds=72000)))
    """
    return datetime.datetime.fromisoformat(generated_at)


def __parse_name(log_message:str) -> str:
    """
        Given a quickstart log message, returns the name of the profile

        >>> __parse_name('can not parse name from 06/Aug/2019:14:20:02.552 309/#upd:brick_ovens_for_sale_cc_210104:2d6f: INFO     wordstream.update.UpdateAlertsCommand: Finished updating profile brick_ovens_for_sale_cc_210104! (4173 of 8280)')
        'brick_ovens_for_sale_cc_210104'
    """
    match = re.search('upd:(.+?):', log_message)
    if not match:
        print('can not parse name from %s' % log_message)
        return None
    return match.group(1).strip()


def __parse_num_totals_in_run(log_message:str) -> int:
    """
        >>> __parse_num_totals_in_run('can not parse name from 06/Aug/2019:14:20:02.552 309/#upd:brick_ovens_for_sale_cc_210104:2d6f: INFO     wordstream.update.UpdateAlertsCommand: Finished updating profile brick_ovens_for_sale_cc_210104! (4173 of 8280)')
        8280
    """
    match = re.search('\d+ of (\d+)\)', log_message)
    if not match:
        print('can not parse run count from %s' % log_message)
        return None
    return int(match.group(1).strip())


if __name__ == '__main__':
    main()
