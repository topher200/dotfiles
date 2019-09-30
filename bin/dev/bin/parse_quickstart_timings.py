"""
    Compare timings between normal Quickstart and "forced Shopping" Quickstart.

    # Usage
    ## Prerequisites
    - Requires python 3.7
    - Requires the papertrail-cli Ruby gem. Requires credentials for Papertrail to be set up.

    ## Before you can run this script...
    Download logs from papertrail into a file using a command like this:
        papertrail "'Done running activity task CleanupSuccessfulQuickstart!' OR 'Starting download account structure for profile ID' OR 'Done running activity task RunProductPartitionDailyReport' OR 'Done running activity task RunShoppingPerformanceDailyReport'" --json --min-time '2019-04-29' --max-time '2019-05-01' > pt.txt

    NOTE: You must use --min-time and --max-time, or papertrail-cli will save the JSON in an unsupported format.

    ## Running the script
        python parse_quickstart_timings.py

    ## Tests
        python -m doctest parse_quickstart_timings.py
"""


from typing import Dict
import collections
import dataclasses
import datetime
import json
import pprint
import re


JSON_FILE = 'pt.txt'


@dataclasses.dataclass()
class Timings:
    start: datetime.datetime = None
    product_partition: datetime.datetime = None
    shopping: datetime.datetime = None
    cleanup: datetime.datetime = None


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

    same_time_profiles = []
    skip_profiles = []
    slower_profiles = []
    for name, timings in cache.items():
        start_time = timings.start
        end_time = timings.cleanup
        if timings.product_partition and timings.shopping:
            shopping_end = max(timings.product_partition, timings.shopping)
        elif timings.product_partition:
            shopping_end = timings.product_partition
        elif timings.shopping:
            shopping_end = timings.shopping
        else:
            shopping_end = None

        if not end_time or not start_time or not shopping_end:
            print('skipping {}'.format(name))
            skip_profiles.append(name)
            continue

        actual_time = end_time - start_time
        shopping_time = shopping_end - start_time

        if shopping_time < actual_time:
            print(f'QS took {actual_time}. {name}')
            same_time_profiles.append(name)
        else:
            print(f'QS took {actual_time}, would have taken {shopping_time}. {name}')
            slower_profiles.append(name)

    print(
        f'{len(slower_profiles)} quickstarts would have been slower, '
        f'{len(same_time_profiles)} would have been the same. '
        f'{len(skip_profiles)} profiles were skipped',
    )
    pprint.pprint(f'slower_profiles: {slower_profiles}')


def __parse_papertrail(papertrail_json:dict) -> Dict[str, Timings]:
    cache = collections.defaultdict(Timings)
    for event in papertrail_json['events']:
        if 'swf.quickstart.activity-worker' not in event['program']:
            continue
        message = event['message']
        if any(bad_vendor in message for bad_vendor in ('Bing', 'Facebook')):
            continue
        time_ = __parse_datetime_from_papertrail(event['generated_at'])
        name = __parse_name(message)

        if 'download account' in message and not cache[name].start:
            cache[name].start = time_
        elif 'RunProductPartitionDailyReport' in message and not cache[name].product_partition:
            cache[name].product_partition = time_
        elif 'RunShoppingPerformanceDailyReport' in message and not cache[name].shopping:
            cache[name].shopping = time_
        elif 'CleanUp' in message and not cache[name].cleanup:
            cache[name].cleanup = time_
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

        >>> __parse_name('30/Apr/2019:17:35:18.390 6901/#prod!432449!ADWORDS!quick_start:proformance_canine_cc_38434: INFO     engine.services.wordstream.swf_quickstart.adwords.AdwordsQuickstartSwfActivityWorker: Done running activity task CleanUpSuccessfulQuickstart!')
        'proformance_canine_cc_38434'
        >>> __parse_name('30/Apr/2019:19:33:18.006 7087/#prod!432473!BING_ADS!quick_start:adwords_cid-1519987162_cc_311550: INFO     engine.services.wordstream.swf_quickstart.bing.BingQuickstartSwfActivityWorker: [Downloading account structure for profile ID 432473  - START] Starting download account structure for profile ID [432473] - 0.00%')
        'adwords_cid-1519987162_cc_311550'
        >>> __parse_name('30/Apr/2019:20:30:33.521 25518/#prod!372274!ADWORDS!quick_start:k-line : DEBUG    engine.services.wordstream.swf_quickstart.adwords.AdwordsQuickstartSwfActivityWorker: [Downloading account structure for profile ID 372274 - ON_GOING] Starting download account structure for profile ID [372274] - 1.00%')
        'k-line'
    """
    match = re.search('quick_start:(.+?):', log_message)
    if not match:
        print('can not parse name from %s' % log_message)
        return None
    return match.group(1).strip()


if __name__ == '__main__':
    main()
