"""
    Compare timings in the logs to determine how long APG requests take to complete.

    # Usage
    ## Prerequisites
        - Requires python 3.7

    ## Running the script
        - point DEBUG_LOG_FILE to a local download of the APGREPORT ACTIVITY_WORKER log
        $ python parse_apg_timings.py

    ## Tests
        $ python -m doctest parse_apg_timings.py
"""


import collections
import dataclasses
import datetime
import pprint
import re
import typing


# here's a sample of the log lines we expect to see for a completed report
"""
23/Aug/2019:11:39:42.632 27377/#aws3-perftest-three-1478!3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2!ADWORDS!adwords_grader:110435: DEBUG    engine.services.wordstream.swf_apg.APGActivityWorker: APGCheckAccountServiceToken
23/Aug/2019:11:47:46.414 29530/#aws3-perftest-three-1478!3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2!ADWORDS!adwords_grader:110435: DEBUG    engine.services.wordstream.swf_apg.APGActivityWorker: [APG-COMPLETED] - For grader:110435 - request_hash:3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2 - is_admin:False - is_tracker:True
23/Aug/2019:11:47:47.113 29530/#aws3-perftest-three-1478!3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2!ADWORDS!adwords_grader:110435: DEBUG    engine.services.wordstream.swf_apg.APGActivityWorker: ###### after Completed activity APGSyncReportToMarketo - time taken 0.623688936234 seconds
23/Aug/2019:11:47:51.604 29209/#aws3-perftest-three-1478!3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2!ADWORDS!adwords_grader:110435: DEBUG    engine.services.wordstream.swf_apg.APGActivityWorker: ###### after Completed activity APGSendReportEmail - time taken 2.64270114899 seconds
"""


DEBUG_LOG_FILE = '/tmp/debug.log'
OUTPUT_LOG_FILE = '/tmp/durations.txt'


@dataclasses.dataclass(frozen=True)
class GraderHash():
    hash_string: str


@dataclasses.dataclass()
class Timings:
    apg_start: datetime.datetime = None
    apg_completed: datetime.datetime = None


@dataclasses.dataclass(frozen=True)
class ParsedLogLine:
    @dataclasses.dataclass(frozen=True)
    class LogEvent:
        name: str

    grader_hash: GraderHash
    time: datetime.datetime
    log_event: LogEvent


EVENT_NAME_BY_LogEvent_NAME = {
    'APGCheckAccountServiceToken': 'apg_start',
    '[APG-COMPLETED]': 'apg_completed',
}


def main():
    timings = collections.defaultdict(Timings)
    with open(DEBUG_LOG_FILE) as f:
        for line in f:
            parsed_log_line = __parse_log_line(line)
            if not parsed_log_line:
                # must not have been an event we care about
                continue
            try:
                event_name = EVENT_NAME_BY_LogEvent_NAME[parsed_log_line.log_event.name]
            except:
                raise
            setattr(timings[parsed_log_line.grader_hash], event_name, parsed_log_line.time)

    durations = set()
    for timing in timings.values():
        if not timing.apg_start or not timing.apg_completed:
            continue
        timedelta = timing.apg_completed - timing.apg_start
        durations.add(timedelta.total_seconds())

    pprint.pprint(sorted(durations))
    with open(OUTPUT_LOG_FILE, 'w') as f:
        for duration in sorted(durations):
            print(str(duration), file=f)


def __parse_datetime(dt: str) -> datetime.datetime:
    """
    >>> __parse_datetime('23/Aug/2019:11:39:42.632')
    datetime.datetime(2019, 8, 23, 11, 39, 42, 632000)
    """
    return datetime.datetime.strptime(dt, '%d/%b/%Y:%H:%M:%S.%f')


def __parse_log_line(line: str) -> typing.Optional[ParsedLogLine]:
    """
    >>> __parse_log_line("23/Aug/2019:11:39:42.632 27377/#aws3-perftest-three-1478!3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2!ADWORDS!adwords_grader:110435: DEBUG    engine.services.wordstream.swf_apg.APGActivityWorker: APGCheckAccountServiceToken")
    ParsedLogLine(grader_hash=GraderHash(hash_string='3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2'), time=datetime.datetime(2019, 8, 23, 11, 39, 42, 632000), event=ParsedLogLine.Event(name='APGCheckAccountServiceToken'))
    >>> __parse_log_line("23/Aug/2019:11:39:42.632 27377/#aws3-perftest-three-1478!3c4b1f8a1460731bfe02c691a45c0767a5c607eef86bccd4631a77a46e364fb2!ADWORDS!adwords_grader:110435: DEBUG    engine.services.wordstream.swf_apg.APGActivityWorker: FakeEventName")

    """
    REGEX_PATTERN = '(\S+) \d+/(?:\w|#|-)+!(\w{64})!.*: (\S+)'
    match = re.search(REGEX_PATTERN, line)
    if not match:
        return None
    timestamp_str, hash_str, event_str = match.groups()
    if not event_str in EVENT_NAME_BY_LogEvent_NAME:
        return None
    return ParsedLogLine(
        grader_hash=GraderHash(hash_string=hash_str),
        time=__parse_datetime(timestamp_str),
        log_event=ParsedLogLine.LogEvent(name=event_str),
    )


if __name__ == '__main__':
    main()
