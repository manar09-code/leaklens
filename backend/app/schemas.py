"""
Schémas Pydantic : définissent et valident automatiquement
le format des requêtes/réponses de l'API LEAKLENS.
"""

from typing import List, Optional
from pydantic import BaseModel, Field, field_validator


class DiagnosticRequest(BaseModel):
    monthly_usage_m3: float = Field(..., gt=0, description="Consommation mensuelle en m3")
    usage_hours: List[str] = Field(default_factory=list, description="Ex: ['morning','evening','night']")
    fixture_count: int = Field(..., ge=1, description="Nombre de points d'eau (robinets, douche, etc.)")
    primary_fixture: str = Field(..., description="Ex: 'shower', 'toilet', 'kitchen', 'garden'")

    @field_validator("usage_hours")
    @classmethod
    def normalize_hours(cls, v):
        allowed = {"morning", "afternoon", "evening", "night"}
        cleaned = [h.strip().lower() for h in v]
        for h in cleaned:
            if h not in allowed:
                raise ValueError(f"usage_hours doit contenir des valeurs parmi {allowed}, reçu '{h}'")
        return cleaned

    class Config:
        json_schema_extra = {
            "example": {
                "monthly_usage_m3": 35,
                "usage_hours": ["morning", "evening"],
                "fixture_count": 6,
                "primary_fixture": "shower",
            }
        }


class DiagnosticResponse(BaseModel):
    leak_detected: bool
    confidence: int = Field(..., ge=0, le=100)
    estimated_waste_liters_per_day: float
    estimated_monthly_cost_dt: float
    suspected_fixture: Optional[str]
    explanation: str
