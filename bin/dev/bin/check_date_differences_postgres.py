#!/usr/bin/env python3
import asyncio
import logging

import retry # pip install retry


MIN_ACCOUNT_ID = 0
MAX_ACCOUNT_ID = 80000

# certain account IDs are known to take too long to query against (AWS2)
TAKES_TOO_LONG = {
    63119,
    75691,
}

RANGE_INCREMENT = 10
NUM_PARALLEL_JOBS = 10
POSTGRES_CALL = '" SELECT pr.account_id, Max(pr.date)  AS "performance_report_max_date", Max(prs.date) AS "performance_report_segmented_max_date" FROM performance_report AS pr JOIN performance_report_segmented AS prs ON pr.account_id = prs.account_id WHERE pr.date > \'2019-06-23\' and prs.date > \'2019-06-23\' and pr.account_id >= {} AND pr.account_id < {} GROUP BY pr.account_id HAVING Max(pr.date) != Max(prs.date); "'
RUN_COMMAND = "export PGPASSWORD='***REMOVED***'; psql -U tbrown -h readonly.aws2.wordstream.com --no-psqlrc --tuples-only --no-align --field-separator ',' -d adwords -c {}"


class ShellCallError(Exception):
    pass


logging.basicConfig(level=logging.INFO)
logging.getLogger('asyncio').setLevel(logging.WARN)


@retry.retry(ShellCallError, tries=10, delay=.1, backoff=2)
async def __make_psql_call(run_command:str) -> str:
    proc = await asyncio.create_subprocess_shell(run_command)
    stdout, stderr = await proc.communicate()
    await proc.wait()
    if proc.returncode != 0 or stderr:
        logging.debug('- subprocess failed. call: "%s", response: "%s"', run_command, stderr)
        raise ShellCallError('call failed. request: "%s", response: "%s"' % (run_command, stderr))
    return stdout


async def __query_account_id_range(account_id_min:int, account_id_max:int) -> str:
    query = POSTGRES_CALL.format(account_id_min, account_id_max)
    run_command = RUN_COMMAND.format(query)
    try:
        res = await __make_psql_call(run_command)
    except ShellCallError as e:
        logging.debug('postgres call failed permanently. %s', e)
        return '%s' % e
    else:
        return res


async def __consume_command_jobs(consumer_number:int, queue:asyncio.Queue) -> None:
    while True:
        start, end = await queue.get()
        try:
            logging.debug('- running from %s to %s on consumer #%s', start, end, consumer_number)
            res = await __query_account_id_range(start, end)
            if res and res.strip():
                logging.info(res.strip())
            logging.debug('- ran from %s to %s on consumer #%s', start, end, consumer_number)
        except Exception:
            logging.exception('error running consumed job')
        finally:
            queue.task_done()


async def __run_jobs() -> None:
    queue = asyncio.Queue()
    consumers = [asyncio.create_task(__consume_command_jobs(i, queue)) for i in range(NUM_PARALLEL_JOBS)]
    for start in range(MIN_ACCOUNT_ID, MAX_ACCOUNT_ID, RANGE_INCREMENT):
        end = start + RANGE_INCREMENT
        if any(start <= i < end for i in TAKES_TOO_LONG):
            logging.debug('- skipping range: covers an account in %s', TAKES_TOO_LONG)
            continue
        await queue.put((start, end))
    await queue.join()
    for c in consumers:
        c.cancel()


def main():
    asyncio.run(__run_jobs(), debug=True)


main()
