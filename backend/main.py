from datetime import datetime, timezone
from typing import List

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from database import (
    check_mongodb_connection,
    get_diagnostic,
    save_diagnostic,
)
from services.anomaly import detect_water_anomaly
from services.gemini import analyze_water_usage


app = FastAPI(title="LEAKLENS API")


class WaterUsageRequest(BaseModel):
    monthly_volume_m3: float
    usual_usage_hours: List[str]
    faucet_count: int
    most_used_fixture: str
    nighttime_flow_detected: bool
    estimated_night_flow_liters: float


@app.get("/")
def root():
    return {"message": "LEAKLENS API is running"}


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.get("/health/db")
def database_health():
    try:
        check_mongodb_connection()
        return {"status": "healthy", "database": "mongodb"}
    except Exception:
        return {"status": "unhealthy", "database": "mongodb"}


@app.post("/api/analyze")
def analyze(request: WaterUsageRequest):
    anomaly = detect_water_anomaly(
        nighttime_flow_liters=request.estimated_night_flow_liters,
        usual_usage_hours=request.usual_usage_hours,
    )

    diagnostic_input = {
        **request.model_dump(),
        "anomaly_detected": anomaly.anomaly_detected,
        "anomaly_score": anomaly.anomaly_score,
        "risk_level": anomaly.risk_level,
        "evidence": anomaly.evidence,
    }

    diagnostic = analyze_water_usage(diagnostic_input)

    record = {
        "created_at": datetime.now(timezone.utc),
        "input": request.model_dump(),
        "anomaly": {
            "detected": anomaly.anomaly_detected,
            "score": anomaly.anomaly_score,
            "risk_level": anomaly.risk_level,
            "estimated_loss_liters_day": anomaly.estimated_loss_liters_day,
            "evidence": anomaly.evidence,
        },
        "diagnostic": diagnostic,
    }

    diagnostic_id = save_diagnostic(record)

    return {
        "status": "success",
        "diagnostic_id": diagnostic_id,
        "anomaly": {
            "detected": anomaly.anomaly_detected,
            "score": anomaly.anomaly_score,
            "risk_level": anomaly.risk_level,
            "evidence": anomaly.evidence,
        },
        "diagnostic": diagnostic,
    }


@app.get("/api/diagnostics/{diagnostic_id}")
def diagnostic_details(diagnostic_id: str):
    document = get_diagnostic(diagnostic_id)

    if document is None:
        raise HTTPException(
            status_code=404,
            detail="Diagnostic not found",
        )

    return {
        "status": "success",
        "diagnostic": document,
    }
