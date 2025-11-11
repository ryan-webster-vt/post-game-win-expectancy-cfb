import boto3
import json
import datetime
import pandas as pd
import numpy as np

def lambda_handler(event, context):
    # Fetch data
    s3 = boto3.client('s3')
    bucket_name = 'my-cfb-data-894398043980'
    object_key = 'filtered-data/*.parquet'

    response_data = s3.get_object(Bucket = bucket_name, Key = object_key)
    df = response_data['Body'].read().decode('utf-8')

    # Fetch model
    with open('model.json', 'r') as f:
        info = json.load(f)
    
    coef = np.array(info["coef"]).flatten()
    intercept = info["intercept"][0]
    means = np.array(info["scaler_mean"])
    scales = np.array(info["scaler_scale"])
    feature_order = info["feature_order"]

    # Scale features
    X = df['feature_order']
    X_scaled = (X - means) / scales

    # Compute predictions
    z = np.dot(X_scaled, coef) + intercept

    prob = 1 / (1 + np.exp(-z))

    pred_class = (prob >= 0.5).astype(int)

    # Save results
    df["predicted_prob"] = prob
    df["predicted_class"] = pred_class


    df.to_csv(f"s3://{bucket_name}/final_output_{get_week()}")

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








