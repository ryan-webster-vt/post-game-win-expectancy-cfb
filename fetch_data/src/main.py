import os
import requests
import pandas as pd
import awswrangler as wr
from datetime import date

API_URL = "https://api.collegefootballdata.com"
API_KEY = os.environ["API_KEY"]
S3_BUCKET = os.environ["S3_BUCKET"]
HEADERS = {"Authorization": f"Bearer {API_KEY}"}


def lambda_handler(event, context):
    week_number = get_week()

    # Fetch and save advanced stats
    fetch_and_save("stats/game/advanced", week_number, f"game_metrics/advanced_stats_week_{week_number}.parquet")

    # Fetch and save games
    fetch_and_save("games", week_number, f"game_results/games_week_{week_number}.parquet")

    return {"statusCode": 200}


def fetch_and_save(endpoint, week_number, s3_key):
    """Generic API fetch + save to S3 parquet"""
    url = f"{API_URL}/{endpoint}"
    params = {"year": 2025, "week": week_number, "excludeGarbageTime": True}

    r = requests.get(url, params=params, headers=HEADERS)
    r.raise_for_status()  # ensures Lambda fails on bad response
    data = r.json()

    wr.s3.to_parquet(
        df=pd.json_normalize(data),
        path=f"s3://{S3_BUCKET}/{s3_key}",
        index=False
    )


def get_week(today=None):
    if today is None:
        today = date.today()

    season_start = date(2025, 8, 23)
    season_end = date(2025, 12, 13)

    if today < season_start:
        return 0
    if today > season_end:
        return "season_over"

    days_since_start = (today - season_start).days
    return days_since_start // 7
