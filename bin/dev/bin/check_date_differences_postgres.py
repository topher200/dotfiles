#!/usr/bin/env python3
import subprocess

import retry # pip install retry


MIN_ACCOUNT_ID = 0
MAX_ACCOUNT_ID = 76000

# certain account IDs are known to take too long to query against (AWS2)
TAKES_TOO_LONG = {
    63119,
    75691,
}

RANGE_INCREMENT = 1
POSTGRES_CALL = '" SELECT pr.account_id, Max(pr.date)  AS "performance_report_max_date", Max(prs.date) AS "performance_report_segmented_max_date" FROM performance_report AS pr JOIN performance_report_segmented AS prs ON pr.account_id = prs.account_id WHERE pr.date > \'2019-06-23\' and prs.date > \'2019-06-23\' and pr.account_id >= {} AND pr.account_id < {} GROUP BY pr.account_id HAVING Max(pr.date) != Max(prs.date); "'
RUN_COMMAND = "export PGPASSWORD='***REMOVED***'; psql -U tbrown -h readonly.aws2.wordstream.com --no-psqlrc --tuples-only --no-align --field-separator ',' -d adwords -c {}"


@retry.retry(subprocess.CalledProcessError, tries=10, delay=.1, backoff=2)
def __make_psql_call(run_command:str) -> str:
    return subprocess.check_output(
        run_command,
        shell=True,
        text=True,
        stderr=subprocess.STDOUT,
    )

def __query_account_id_range(account_id_min, account_id_max):
    query = POSTGRES_CALL.format(account_id_min, account_id_max)
    run_command = RUN_COMMAND.format(query)
    try:
        return __make_psql_call(run_command)
    except subprocess.CalledProcessError as e:
        print('postgres call failed. request:', e.cmd, 'response:', e.output)
        return e.output


def main():
    for start in range(MIN_ACCOUNT_ID, MAX_ACCOUNT_ID, RANGE_INCREMENT):
        end = start + RANGE_INCREMENT
        print('- running from {} to {}'.format(start, end))
        if any(start <= i < end for i in TAKES_TOO_LONG):
            print('- skipping range: covers an account in {}'.format(TAKES_TOO_LONG))
            continue
        res = __query_account_id_range(start, end).strip()
        if res:
            print(res)
        print('- ran from {} to {}'.format(start, end))


main()
