from dataclasses import dataclass


@dataclass
class AnomalyResult:
    anomaly_detected: bool
    anomaly_score: float
    estimated_loss_liters_day: float
    risk_level: str
    evidence: list[str]


def detect_water_anomaly(
    nighttime_flow_liters: float,
    usual_usage_hours: list[str],
    observation_hours: float = 8.0,
) -> AnomalyResult:
    """
    Simple MVP anomaly detector.

    Assumes nighttime_flow_liters represents water consumed during a period
    when no intentional usage should normally occur.
    """

    if nighttime_flow_liters < 0:
        raise ValueError("nighttime_flow_liters cannot be negative")

    if observation_hours <= 0:
        raise ValueError("observation_hours must be greater than zero")

    flow_rate = nighttime_flow_liters / observation_hours

    if nighttime_flow_liters == 0:
        return AnomalyResult(
            anomaly_detected=False,
            anomaly_score=0.0,
            estimated_loss_liters_day=0.0,
            risk_level="low",
            evidence=["No off-hours water flow was detected."],
        )

    if nighttime_flow_liters < 10:
        score = 0.35
        risk = "low"
    elif nighttime_flow_liters < 25:
        score = 0.60
        risk = "medium"
    else:
        score = 0.87
        risk = "high"

    evidence = [
        f"{nighttime_flow_liters:.1f} L of water was observed during off-hours.",
        f"Estimated off-hours flow rate: {flow_rate:.2f} L/hour.",
        f"Normal household usage windows: {', '.join(usual_usage_hours)}.",
    ]

    return AnomalyResult(
        anomaly_detected=True,
        anomaly_score=score,
        estimated_loss_liters_day=nighttime_flow_liters,
        risk_level=risk,
        evidence=evidence,
    )
