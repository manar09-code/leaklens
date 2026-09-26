import csv
from collections import defaultdict
from datetime import datetime
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DATA_PATH = PROJECT_ROOT / "data" / "sample_usage.csv"


def summarize_sample_usage(path: str | None = None) -> dict:
    data_path = Path(path) if path else DEFAULT_DATA_PATH

    rows = []

    with open(data_path, newline="") as file:
        for row in csv.DictReader(file):
            timestamp = datetime.fromisoformat(row["timestamp"])
            rows.append(
                {
                    "timestamp": timestamp,
                    "flow_liters": float(row["flow_liters"]),
                }
            )

    rows.sort(key=lambda row: row["timestamp"])

    night_by_day = defaultdict(list)

    for row in rows:
        if 0 <= row["timestamp"].hour < 6:
            night_by_day[row["timestamp"].date()].append(row["flow_liters"])

    days = sorted(night_by_day)

    if len(days) < 10:
        raise ValueError("Not enough telemetry days for comparison")

    baseline_days = days[:5]
    recent_days = days[-5:]

    baseline_values = [
        value for day in baseline_days for value in night_by_day[day]
    ]

    recent_values = [
        value for day in recent_days for value in night_by_day[day]
    ]

    baseline_hourly = sum(baseline_values) / len(baseline_values)
    recent_hourly = sum(recent_values) / len(recent_values)

    baseline_night_liters = baseline_hourly * 6
    recent_night_liters = recent_hourly * 6

    excess_liters_day = max(
        0.0,
        recent_night_liters - baseline_night_liters,
    )

    return {
        "baseline_night_liters": round(baseline_night_liters, 2),
        "recent_night_liters": round(recent_night_liters, 2),
        "excess_liters_day": round(excess_liters_day, 2),
        "baseline_days": [day.isoformat() for day in baseline_days],
        "recent_days": [day.isoformat() for day in recent_days],
    }
