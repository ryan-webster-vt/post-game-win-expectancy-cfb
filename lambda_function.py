import awswrangler as wr
import pandas as pd
import requests
import boto3
import json
import os
from io import StringIO

s3_bucket = "my-cfb-data-894398043980/advance_metric_game_data"
s3_key = "cfb_data.parquet"

s3 = boto3.client('s3')

def lambda_handler(event, context):
    api_key = os.environ["API_KEY"]

    # Website information
    url = "https://api.collegefootballdata.com/stats/game/advanced"
    params = {"year": 2025, "week": 1, "excludeGarbageTime": True}
    headers = {"Authorization": f"Bearer {api_key}"}

    # Call the API
    r = requests.get(url, params=params, headers=headers)
    data = r.json()

    # Upload parquet to S3
    wr.s3.to_parquet(
        df=pd.json_normalize(data),
        path=f"s3://{s3_bucket}/{s3_key}",
        index=False
    )

    return {"status": "success"}
