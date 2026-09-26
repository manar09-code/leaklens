import csv
import random
from datetime import datetime, timedelta

random.seed(42)

start = datetime(2026, 9, 1, 0, 0)
rows = []

for i in range(24 * 14):
    timestamp = start + timedelta(hours=i)
    hour = timestamp.hour

    if 6 <= hour < 9 or 18 <= hour < 22:
        base = random.uniform(2.0, 5.0)
    elif 8 <= hour < 18:
        base = random.uniform(0.5, 2.0)
    else:
        base = random.uniform(0.0, 0.2)

    if timestamp >= datetime(2026, 9, 10) and 0 <= hour < 6:
        base += random.uniform(3.5, 4.5)

    rows.append({
        "timestamp": timestamp.isoformat(),
        "flow_liters": round(base, 2),
        "scenario": (
            "hidden_leak"
            if timestamp >= datetime(2026, 9, 10) and 0 <= hour < 6
            else "normal"
        ),
    })

with open("data/sample_usage.csv", "w", newline="") as file:
    writer = csv.DictWriter(
        file,
        fieldnames=["timestamp", "flow_liters", "scenario"]
    )
    writer.writeheader()
    writer.writerows(rows)

print(f"Created {len(rows)} hourly readings.")
