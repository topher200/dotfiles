from __future__ import print_function
import argparse
import csv
import json
import os
import re

"""
    Assembles Alert data from the alerts and alerts_kv table into single rows.

    Given a source CSV filepath and a destination DIRECTORY, reads the CSV
    into a dictionary format and then writes it back to a CSV where each row
    is one alert.

    The query expected is:

    SELECT a.alert_id,
           a.account_id,
           acc.profile_id,
           a.alert_type,
           kvc.name AS campaign_name,
           kvc.advertising_channel_type AS campaign_advertising_channel_type,
           kv.key,
           kv.value
    FROM alerts a
    LEFT JOIN
        (SELECT kv.alert_id,
                kv.value,
                c.id,
                c.name,
                c.advertising_channel_type
         FROM alerts_kv kv
         JOIN campaign c ON kv.value::INTEGER=c.id
         WHERE kv.key='campaign_id') kvc ON a.alert_id=kvc.alert_id
    JOIN alerts_kv kv ON a.alert_id=kv.alert_id
    JOIN account acc ON a.account_id = acc.id
    WHERE is_latest IS TRUE
        AND alert_type='DEVICE_BID_ADJUSTMENT_ALERT'
        AND kv.key!='campaign_id'

    The final required columns are:
    - alert_id
    - account_id
    - profile_id
    - campaign_name
    - campaign_advertising_channel_type
    - avg_pos
    - clicks
    - conv
    - cost
    - device_type
    - impressions
    - new_bid_modifier
    - orig_bid_modifier
"""

KEY_REGEX = "(\d+)(\w+)"
"""
RegEx for alerts_kv in format (alert #)(key)

example: `0annualized_spend`
"""

KEY_MAP = {}
""" Mapping of SQL keys to CSV keys """


KEY_WHITELIST = [
    'avg_pos',
    'clicks',
    'conv',
    'cost',
    'device_type',
    'impressions',
    'new_bid_modifier',
    'orig_bid_modifier',
]
"""
List of all alerts_kv keys to add to alert candidates that follow the format
mentioned by the KEY_REGEX.
"""

DESTINATION_FILENAME = "add_negative_alerts"
"""
The name of the file to write results to. This filename will apply to both
resulting CSV and resulting JSON files.
"""

ROW_POSITIONS = {
    "alert_id": 0,
    "account_id": 1,
    "profile_id": 2,
    "alert_type": 3,
    "campaign_name": 4,
    "campaign_advertising_channel_type": 5,
    "key": 6,
    "value": 7
}
""" Mapping of row indices to the column name. Makes it easier if format changes """

def run(source, destination, debug=False, save_json=False):
    """
        row format:
            [0] alert_id
            [1] account_id
            [2] profile_id
            [3] alert_type
            [4] campaign_name
            [5] campaign_advertising_channel_type
            [6] key
            [7] value

        alerts_parsed format:
        {
            alert_id: {
                account_id,
                profile_id,
                campaign_name,
                campaign_advertising_channel_type,
                alerts: [
                    {
                        avg_pos,
                        new_bid_modifier,
                        conv,
                        orig_bid_modifier,
                        cost,
                        device_type,
                        impressions,
                        clicks,
                    }
                ]
            }
        }
    """
    alerts_parsed = {}

    with open(source, "rb") as csvfile:
        alerts_csv_reader = csv.reader(csvfile)

        for row in alerts_csv_reader:
            if len(row) != len(ROW_POSITIONS) or not row[ROW_POSITIONS["alert_id"]].isdigit():
                continue

            # alert ID
            if row[ROW_POSITIONS["alert_id"]] not in alerts_parsed:
                if debug:
                    print("Working on alert ID:", row[ROW_POSITIONS["alert_id"]])
                alerts_parsed[row[ROW_POSITIONS["alert_id"]]] = {
                    "account_id": row[ROW_POSITIONS["account_id"]],
                    "profile_id": row[ROW_POSITIONS["profile_id"]],
                    "campaign_name": row[ROW_POSITIONS["campaign_name"]],
                    "campaign_advertising_channel_type":
                    row[ROW_POSITIONS["campaign_advertising_channel_type"]],
                    "alerts": []
                }

            key_match = re.match(KEY_REGEX, row[ROW_POSITIONS["key"]])
            if key_match:
                if debug:
                    print("Working on key:", key_match.group(1), key_match.group(2))

                extracted_key = key_match.group(2)
                if extracted_key not in KEY_WHITELIST:
                    continue
                if extracted_key in KEY_MAP:
                    extracted_key = KEY_MAP[extracted_key]
                # Find alerts array for the alert ID
                alerts_array = alerts_parsed[row[ROW_POSITIONS["alert_id"]]]["alerts"]
                # See reference for RegEx above for groups
                alerts_array_index = int(key_match.group(1))
                # Append new alert object if necessary
                while len(alerts_array) <= alerts_array_index:
                    alerts_array.append({})
                # Save key-value pair
                alerts_array[alerts_array_index][extracted_key] = row[ROW_POSITIONS["value"]]
    if save_json:
        json_destination = DESTINATION_FILENAME + ".json"
        if destination is not None:
            json_destination = os.path.join(destination, json_destination)
        with open(json_destination, "w") as jsonfile:
            jsonfile.write(json.dumps(alerts_parsed, indent=2))

    dest_file = DESTINATION_FILENAME + ".csv"
    if destination is not None:
        dest_file = os.path.join(destination, dest_file)

    with open(dest_file, "w") as new_csv:
        csv_writer = csv.writer(new_csv, dialect="excel")
        csv_writer.writerow([
            "alert_id",
            "account_id",
            "profile_id",
            "campaign_name",
            "campaign_advertising_channel_type",

            'avg_pos',
            'clicks',
            'conv',
            'cost',
            'device_type',
            'impressions',
            'new_bid_modifier',
            'orig_bid_modifier',
        ])
        for alert_id, obj in alerts_parsed.items():
            for candidate in obj["alerts"]:
                try:
                    row_array = [
                        alert_id,
                        obj["account_id"],
                        obj["profile_id"],
                        obj["campaign_name"],
                        obj["campaign_advertising_channel_type"],

                        candidate['avg_pos'],
                        candidate['clicks'],
                        candidate['conv'],
                        candidate['cost'],
                        candidate['device_type'],
                        candidate['impressions'],
                        candidate['new_bid_modifier'],
                        candidate['orig_bid_modifier'],
                    ]
                except KeyError:
                    print("Unable to parse alert id %s. %s, %s" % (alert_id, obj, candidate))
                    continue
                csv_writer.writerow(row_array)

    if debug:
        print("Total alerts (by alert ID):", len(alerts_parsed))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("source", help="The source CSV file to compile")
    parser.add_argument("-d", "--destination", help="The destination filepath to write the resulting CSV file. By default will save to same directory as source with filename 'add_negative_alerts.csv'.")
    parser.add_argument("--debug", help="Enables debug print messages", action="store_true")
    parser.add_argument("--json", help="Will also save a JSON version of alerts", action="store_true")

    args = parser.parse_args()
    run(args.source, args.destination, debug=args.debug, save_json=args.json)
